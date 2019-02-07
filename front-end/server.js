const {parse} = require('url');
const next = require('next');
const app = next({dev: process.env.NODE_ENV !== 'production'});
const handler = app.getRequestHandler();
const port = process.env.PORT || 3000;

const express = require('express');

process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = 0;

app.prepare().then(() => {
  express()
    .use('*', function(req, res, next) {
      const parsedUrl = parse(req.url, true);
      const subdomains = req.subdomains;
      const {pathname, query} = parsedUrl;

      if (subdomains.length) {
        const normalizedPath = pathname === '/' ? '' : pathname;
        const subdomainPath = '/storefront' + normalizedPath;

        const subdomainQuery = {
          subdomain: subdomains[0],
          ...query,
        };

        app.render(req, res, subdomainPath, subdomainQuery);
      } else {
        next();
      }
    })
    .use(handler)
    .listen(port);
});
