const env = require('./env-config.js')

module.exports = {
  presets: ['next/babel'],
  plugins: [['transform-define', env], 'inline-react-svg']
}
