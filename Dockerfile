FROM node:14.17.6
# FROM ruby:3.0.2
# FROM ruby:3.1.0
FROM ruby:3.3.1
ENV TZ Asia/Tokyo

COPY --from=node /opt/yarn-* /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
RUN ln -fs /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
 && ln -fs /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npx \
 && ln -fs /opt/yarn/bin/yarn /usr/local/bin/yarn \
 && ln -fs /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg 

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get update -qq && \
  apt-get install -y build-essential \
  libpq-dev \
  postgresql-client \
  && apt-get install -y nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN gem update --system
RUN gem install bundler

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# RUN bundle lock --add-platform x86_64-linux && bundle config set frozen false && bundle install
RUN bundle install

COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

