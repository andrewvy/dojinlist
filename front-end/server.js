const {parse} = require('url');
const next = require('next');
const proxy = require('http-proxy-middleware');
const dev = process.env.NODE_ENV !== 'production';
const app = next({dev: dev});
const handler = app.getRequestHandler();
const port = process.env.PORT || 3000;

const express = require('express');

process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = 0;

app.prepare().then(() => {
  const server = express();

  if (dev) {
    // Make HMR work
    server.use(
      '/_next',
      proxy((pathname, req) => Boolean(req.subdomains.length), {
        target: 'http://localhost:3000',
        changeOrigin: true,
      }),
    );
  }

  server
    .use('*', function(req, res, next) {
      const parsedUrl = parse(req.originalUrl, true);
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

  server.use(handler)

  server.listen(port);
});
