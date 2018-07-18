FROM node:10-alpine

ENV WEBHOOK_SECRET {replace_me_at_runtime}
EXPOSE 4567

RUN mkdir -p /usr/src/app /tmp/webhooks /var/www
WORKDIR /usr/src/app
VOLUME ["/usr/src/app", "/tmp/webhooks", "/var/www"]

RUN npm install -g nodemon
RUN apk --no-cache add vim git
COPY .vimrc /root/.vimrc

COPY package.json /usr/src/app/
COPY . /usr/src/app
RUN npm install

# Use nodemon to start app.
CMD [ "nodemon" ]
