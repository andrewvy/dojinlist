const routes = require('next-routes')

module.exports = routes()
  .add('storefront', '/:storefront_slug', 'storefront')
  .add('album', '/:storefront_slug/:album_slug', 'storefront/albums')
  .add('album_checkout', '/:storefront_slug/:album_slug/checkout', 'storefront/checkout')
