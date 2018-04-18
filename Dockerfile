# ruby:2.1 was used in example, version probably doesn't matter.
FROM ruby:2.1-onbuild

EXPOSE 4567

RUN mkdir -p /tmp

VOLUME /var/www/kaplon.us

CMD ["./hook.rb"]
