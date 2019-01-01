const prod = process.env.NODE_ENV === 'production'
const stage = process.env.UP_STAGE

module.exports = {
  'BACKEND_URL': prod ? 'https://api.dojinlist.co' : 'https://localhost:4001',
  'ASSET_PREFIX': stage ? `/${stage}` : '',
  'TRACKING_ENABLED': prod
}
