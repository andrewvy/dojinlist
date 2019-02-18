const {parse} = require('url');
const next = require('next');
const proxy = require('http-proxy-middleware');
const routes = require('./routes')

const dev = process.env.NODE_ENV !== 'production';
const app = next({dev: dev});
const handler = routes.getRequestHandler(app);
const port = process.env.PORT || 3000;

const config = require('./env-config.js');

const express = require('express');

process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = 0;

app.prepare().then(() => {
  const server = express();

  server.use(handler)

  server.listen(port);
});
