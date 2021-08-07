FROM ruby:2.7.0-alpine

RUN apk update && apk add bash build-base nodejs postgresql-dev tzdata

RUN mkdir /demo_project
WORKDIR /demo_project

COPY Gemfile Gemfile.lock ./

RUN gem install bundler --no-document

RUN bundle install

COPY . .

# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]