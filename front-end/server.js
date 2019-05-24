const { parse } = require('url')
const next = require('next')
const proxy = require('http-proxy-middleware')
const nextI18NextMiddleware = require('next-i18next/middleware')

const routes = require('./routes')
const nextI18next = require('./lib/i18n')

const dev = process.env.NODE_ENV !== 'production'
const app = next({ dev: dev })
const handler = routes.getRequestHandler(app)
const port = process.env.PORT || 3000

const config = require('./env-config.js')

const express = require('express')

process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = 0

app.prepare().then(() => {
  const server = express()

  server.use(nextI18NextMiddleware(nextI18next))
  server.use(handler)

  server.listen(port)
})
