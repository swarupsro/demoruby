FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y build-essential libsqlite3-dev nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

RUN chmod +x bin/*

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint
RUN chmod +x /usr/bin/docker-entrypoint

ENV RAILS_ENV=lab \
    LAB_MODE=1

EXPOSE 3000

ENTRYPOINT ["docker-entrypoint"]
CMD ["bash", "-lc", "bundle exec rails db:prepare && bundle exec rails server -b 0.0.0.0 -p 3000"]
