FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y build-essential libsqlite3-dev nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile ./
RUN bundle config set --local path 'vendor/bundle' \
  && bundle install

COPY . .

ENV RAILS_ENV=lab \
    LAB_MODE=1 \
    BUNDLE_PATH=vendor/bundle

EXPOSE 3000

CMD ["bash", "-lc", "bin/rails db:prepare && bin/rails server -b 0.0.0.0 -p 3000"]
