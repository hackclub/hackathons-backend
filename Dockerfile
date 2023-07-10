FROM ruby:3.2.2 AS base

# Default directory
ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH

# Install gems
WORKDIR $INSTALL_PATH
COPY . .
RUN gem install rails bundler
RUN bundle install

# Start server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

