FROM ruby:3.3.2-slim as base

WORKDIR /hackathons

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"


FROM base as build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config

COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile


COPY . .

RUN bundle exec bootsnap precompile app/ lib/

RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y postgresql-client-15 libvips curl libjemalloc2 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /hackathons /hackathons

RUN useradd hackathons --create-home --shell /bin/bash && \
    chown -R hackathons:hackathons db log storage tmp
USER hackathons:hackathons

ENTRYPOINT ["/hackathons/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
