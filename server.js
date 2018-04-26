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

    var crypto = require('crypto');
    var text = JSON.stringify(req.body);
    var key = process.env.WEBHOOK_SECRET;
    var hash = crypto.createHmac('sha1', key).update(text).digest('hex');
    // Header key value all lower-case here, even though it's mixed-case in GitHub docs.
    winston.info('GitHub HMAC: ' + req.headers['x-hub-signature']);
    winston.info('Calculated:  sha1=' + hash);
    if (req.headers['x-hub-signature'] != 'sha1=' + hash) {
        winston.error('Unable to verify GitHub HMAC header, stranger-danger!');
    } else {
        var exec = require('child_process').exec;
        // Use https address to clone repo and not ssh-URL (eg. NOT git@github.com:jkaplon/alytfeed).
        // Don't need or want any of the key exchange setup required by the ssh-URL.
        var cmd = `
            rm -rf /tmp/webhooks/alytfeed;
            git clone https://github.com/jkaplon/alytfeed.git /tmp/webhooks/alytfeed;
        `
        exec(cmd, function(error, stdout, stderr) {
            if (error) { winston.error(error); }
            winston.info('Latest repo changes cloned from github.com');
            var cmd2 = 'cp /tmp/webhooks/alytfeed/alytfeed.xml /var/www/kaplon.us/alytfeed.xml'
            exec(cmd2, function(error, stdout, stderr) {
                if (error) { winston.error(error); }
                winston.info('Latest alytfeed.xml copied to canonical location.');
            });
        });
    }
});

app.listen(4567, function() {
    winston.info("Started on PORT 4567");
});
