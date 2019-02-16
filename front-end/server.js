const {parse} = require('url');
const next = require('next');
const proxy = require('http-proxy-middleware');

const dev = process.env.NODE_ENV !== 'production';
const app = next({dev: dev});
const handler = app.getRequestHandler();
const port = process.env.PORT || 3000;

const config = require('./env-config.js');

const express = require('express');

process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = 0;

const conditionallyRenderStorefront = function(req, res, next, params) {
  const parsedUrl = parse(req.originalUrl, true);
  const subdomains = req.subdomains;
  const {pathname, query} = parsedUrl;

  if (subdomains.length && !pathname.startsWith('/_next')) {
    const normalizedPath = pathname === '/' ? '' : pathname;
    const subdomainPath = '/storefront' + normalizedPath;

    const subdomainQuery = {
      subdomain: subdomains[0],
      ...query,
      ...req.query
    };

    app.render(req, res, subdomainPath, subdomainQuery);
  } else {
    next();
  }
}

app.prepare().then(() => {
  const server = express();

  server
    .get('/albums/:album_slug/checkout', function(req, res, next) {
      req.query = {
        album_slug: req.params.album_slug,
        ...req.query
      }

      req.originalUrl = '/checkout'

      next()
    })
    .get('/albums/:album_slug', function(req, res, next) {
      req.query = {
        album_slug: req.params.album_slug,
        ...req.query
      }

      req.originalUrl = '/albums'

      next()
    })
    .use('*', function(req, res, next) {
      conditionallyRenderStorefront(req, res, next, "/storefront")
    })

  server.use(handler)

  server.listen(port);
});
