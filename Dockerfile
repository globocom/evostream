FROM ruby:2.3

RUN mkdir -p /app
COPY . /app
WORKDIR /app

RUN bundle install
