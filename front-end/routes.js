const routes = require('next-routes')

module.exports = routes()
  .add('blog-new', '/blog/new', 'blog/new')
  .add('blog-edit', '/blog/:slug/edit', 'blog/edit')
  .add('blog', '/blog/:slug', 'blog')
