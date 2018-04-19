# don't use alpine version here, `bundle install` fails.
FROM ruby:2.5

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app
RUN mkdir -p /tmp

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 4567

CMD ["./hook.rb"]
