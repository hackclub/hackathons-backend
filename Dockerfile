FROM ruby:4.0.6-slim AS base

WORKDIR /hackathons

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    RUBYOPT="--enable-frozen-string-literal" \
    LD_LIBRARY_PATH="/usr/local/lib"


FROM base AS build

# Debian trixie's libheif 1.19.8 has an unfixed heap overflow that public image
# uploads reach through libvips' heifload. Build a patched one and let
# LD_LIBRARY_PATH shadow the distro package. ENABLE_PLUGIN_LOADING=NO compiles
# the codecs in, avoiding a plugin/core ABI version mismatch.
# https://github.com/strukturag/libheif/security/advisories/GHSA-g89c-p67h-r497
ARG LIBHEIF_VERSION=1.23.2
ARG LIBHEIF_SHA256=1405ed070421459b569ff49deab109b7f1a30a447e72a9b20a4154f774634a44

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config libyaml-dev libpq-dev libvips \
      curl ca-certificates cmake libde265-dev libdav1d-dev libaom-dev && \
    curl -sL "https://github.com/strukturag/libheif/archive/refs/tags/v${LIBHEIF_VERSION}.tar.gz" -o /tmp/libheif.tar.gz && \
    echo "${LIBHEIF_SHA256}  /tmp/libheif.tar.gz" | sha256sum -c - && \
    tar xz -C /tmp/ -f /tmp/libheif.tar.gz && \
    cmake -S "/tmp/libheif-${LIBHEIF_VERSION}" -B /tmp/libheif-build --preset=release -DENABLE_PLUGIN_LOADING=NO && \
    cmake --build /tmp/libheif-build -j "$(nproc)" && \
    cmake --install /tmp/libheif-build && \
    ldconfig && \
    mkdir -p /opt/libheif && cp -a /usr/local/lib/libheif.so* /opt/libheif/ && \
    rm -rf /tmp/libheif*

COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile


COPY . .

RUN bundle exec bootsnap precompile app/ lib/

RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y postgresql-common libvips curl ca-certificates lsb-release libjemalloc2 \
      libde265-0 libdav1d7 libaom3 && \
    install -d /usr/share/postgresql-common/pgdg && curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    apt-get update -qq && apt-get install --no-install-recommends -y postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /hackathons /hackathons

# Copy the staged directory, not a glob: COPY dereferences the soname symlinks.
COPY --from=build /opt/libheif/ /usr/local/lib/
RUN ldconfig

RUN useradd hackathons --create-home --shell /bin/bash && \
    chown -R hackathons:hackathons db log storage tmp
USER hackathons:hackathons

ENTRYPOINT ["/hackathons/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
