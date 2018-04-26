var express = require('express');
var app = express();
var bodyParser = require('body-parser');
app.use(bodyParser.json());  // MUST use this, and set GitHub webhook to use application/json Content type.
var winston = require('winston');
winston.add(winston.transports.File, { filename: './logs/webhooks.kaplon.us.log', maxsize: 5000000 });  // 5MB
var fileSystem = require('fs');

app.get('/', function(req, res){
    winston.info("GET /");
    // Respond with static file, contents will be loaded via websocket.
    res.sendFile('index.html', { root: __dirname });
});

app.get('/alytfeed', function(req, res){
    winston.info("GET /");
    // Respond with static file, contents will be loaded via websocket.
    res.sendFile('index.html', { root: __dirname });
});

app.post('/alytfeed', function(req, res) {
    winston.info('Potential post from GitHub webhook.');
    res.status(200).send('OK');  // Go ahead and return an OK to GitHub.

    // TODO: `rm -rf` the /tmp dir (may need to edit Dockerfile to add dir
    // clone from github to get latest version of alytfeed.xml
    // copy latest alytfeed.xml to /var/www/kaplon.us/alytfeed.xml;

    var crypto = require('crypto')
        ,text = JSON.stringify(req.body)
        ,key  = process.env.WEBHOOK_SECRET
        ,hash;

    hash = crypto.createHmac('sha1', key).update(text).digest('hex');
    // Header key value all lower-case here, even though it's mixed-case in GitHub docs.
    winston.info('GitHub HMAC: ' + req.headers['x-hub-signature']);
    winston.info('Calculated:  sha1=' + hash);
});

app.listen(4567, function() {
    winston.info("Started on PORT 4567");
});
