# FROM ruby:3.3.0
# RUN apt-get update -qq && apt-get install -y \
#     build-essential \
#     libpq-dev \
#     nodejs npm\
#     postgresql-client 
FROM se:dev

RUN npm install -g yarn 
# RUN yarn self-update

RUN gem update --system
RUN gem install bundler

WORKDIR /myapp
COPY Gemfile Gemfile.lock /myapp/
RUN bundle install

