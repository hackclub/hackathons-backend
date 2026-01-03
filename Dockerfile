FROM ruby:3.4.8-slim AS base

WORKDIR /hackathons

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"


FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config libyaml-dev libpq-dev libvips

COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile


COPY . .

RUN bundle exec bootsnap precompile app/ lib/

RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y postgresql-common libvips curl ca-certificates lsb-release libtcmalloc-minimal4t64 && \
    install -d /usr/share/postgresql-common/pgdg && curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    apt-get update -qq && apt-get install --no-install-recommends -y postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /hackathons /hackathons

RUN useradd hackathons --create-home --shell /bin/bash && \
    chown -R hackathons:hackathons db log storage tmp
USER hackathons:hackathons

ENTRYPOINT ["/hackathons/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
