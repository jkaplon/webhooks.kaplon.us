var express = require('express');
var app = express();
var bodyParser = require('body-parser');
app.use(bodyParser.text());   // Use defaults for now, size limit is 100kb.
app.use(bodyParser.urlencoded({ extended: true }));   // Also need url encoding to handle login form.
var winston = require('winston');
winston.add(winston.transports.File, { filename: './logs/notes.kaplon.us.log', maxsize: 5000000 });  // 5MB
var fileSystem = require('fs');

app.get('/', function(req, res){
    winston.info("GET /");
    // Respond with static file, contents will be loaded via websocket.
    res.sendFile('index.html');
});

app.post('/alytfeed', function(req, res) {
    winston.info('Potential post from GitHub webhook.');
    res.send(200);  // TODO: look up this syntax

    // TODO: verify GitHup HMAC header (figure out how to store secret word in env-var or config file).
    // then `rm -rf` the /tmp dir (may need to edit Dockerfile to add dir
    // clone from github to get latest version of alytfeed.xml
    // copy latest alytfeed.xml to /var/www/kaplon.us/alytfeed.xml;
    // will def need to edit Dockerfile to make this a mountable volume from host-os.
    // Try to call as an async function, so can go ahead and return 200/ok to GitHub?
    // ...Or, make it synchronous so i can return a meaningful error to GitHub???
    // ?where would i rather look 1st for an error?...logs from this app, or GitHub-webhook-dashboard?
});

http.listen(4567, function() {
    winston.info("Started on PORT 4567");
});
