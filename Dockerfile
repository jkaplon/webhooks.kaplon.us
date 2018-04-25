# Go w/node-8 for now, v10 not available quite yet.
FROM node:8-alpine

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
