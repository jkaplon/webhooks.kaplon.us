# don't use alpine version here, `bundle install` fails.
FROM ruby:2.5

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /tmp/webhooks
RUN mkdir -p /var/www/kaplon.us
VOLUME /tmp/webhooks /var/www/kaplon.us

COPY Gemfile Gemfile.lock ./
RUN bundle install

WORKDIR /usr/src/app
COPY . .

EXPOSE 4567

CMD ["ruby ./hook.rb"]
