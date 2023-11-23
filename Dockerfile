FROM ruby:3.1.4

RUN apt-get update
RUN apt-get install -y libvips libvips-dev libvips-tools

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs
RUN npm install --global yarn

RUN mkdir -p /app
WORKDIR /app
COPY . /app
RUN chmod +x /app/bin/docker-entrypoint

RUN gem install bundler:2.3.7
RUN bundle install --jobs 4 --retry 3 && \
    bundle clean --force && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

# ENV secret_key_base 1
ARG RAILS_ENV
ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_ENV="production" \
    SECRET_KEY_BASE=dummy

RUN yarn install

RUN bundle exec rake assets:precompile
RUN rake tmp:cache:clear

ENTRYPOINT ["/app/bin/docker-entrypoint"]
EXPOSE 3000
VOLUME ["/app/public"]
CMD ["bundle", "exec", "puma"]