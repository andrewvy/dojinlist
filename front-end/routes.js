const routes = require('next-routes')

module.exports = routes()
  .add('terms', '/terms', 'terms')
  .add('privacy', '/privacy', 'privacy')
  .add('cookie_policy', '/cookie-policy', 'cookie-policy')
  .add('register', '/register', 'register')
  .add('login', '/login', 'login')
  .add('logout', '/logout', 'logout')
  .add('blog/hello-world', '/blog/hello-world', 'blog/hello-world')
  .add('styleguide_album', '/styleguide/album', 'styleguide/album')
  .add('styleguide_blog', '/styleguide/blog', 'styleguide/blog')
  .add('styleguide_button', '/styleguide/button', 'styleguide/button')
  .add('styleguide_navigation', '/styleguide/navigation', 'styleguide/navigation')
  .add('styleguide_pill', '/styleguide/pill', 'styleguide/pill')
  .add('styleguide_player', '/styleguide/player', 'styleguide/player')
  .add('styleguide_search', '/styleguide/search', 'styleguide/search')
  .add('styleguide_checkout', '/styleguide/checkout', 'styleguide/checkout')
  .add('storefront', '/:storefront_slug', 'storefront')
  .add('album', '/:storefront_slug/:album_slug', 'storefront/albums')
  .add('album_checkout', '/:storefront_slug/:album_slug/checkout', 'storefront/checkout')
  .add('album_checkout_success', '/:storefront_slug/:album_slug/checkout/success', 'storefront/checkout_success')
