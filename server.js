const express = require('express');
const fs = require('fs');
const { name, url } = require('./package.json');
const path = require('path');
const http = require('http');
const https = require('https');

// variable assignment
const port = 4000;
const dev = process.env.NODE_ENV !== 'production';

console.log(`Starting in ${dev ? 'development' : 'production'} mode`);

// server setup
const app = express();

app.use(express.static(path.join(__dirname, `dist/${name}`)));

app.use('*', (req, res) => {
  res.sendFile(path.join(__dirname, `dist/${name}/index.html`));
});

// server start
if (dev) {
  http.createServer(app).listen(port, err => {
    if (err) throw err;

    console.log('> Listening to port', port);
  });
} else {
  const credentials = {
    cert: fs.readFileSync(
      path.resolve(__dirname, `./letsencrypt/live/${url}/fullchain.pem`)
    ),
    key: fs.readFileSync(
      path.resolve(__dirname, `./letsencrypt/live/${url}/privkey.pem`)
    )
  };

  http
    .createServer((req, res) => {
      res.writeHead(301, {
        Location: `https://${req.headers.host}${req.url}`
      });
      res.end();
    })
    .listen(port);

  https.createServer(credentials, app).listen(8443);

  console.log('> Listening to port 8443');
}
