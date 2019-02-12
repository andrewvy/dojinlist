const prod = process.env.NODE_ENV === 'production'
const stage = process.env.UP_STAGE
const stripeApiKey = process.env.STRIPE_API_KEY
const rootUrl = process.env.ROOT_URL

module.exports = {
  'ROOT_URL': rootUrl ? rootUrl : 'http://dojinlist.local:3000',
  'BACKEND_URL': prod ? 'https://api.dojinlist.co' : 'https://localhost:4001',
  'STRIPE_API_KEY': stripeApiKey ? stripeApiKey : 'pk_test_1YjIMLJ8Talsv8ijFEQBK5Ca',
  'ASSET_PREFIX': stage ? `/${stage}` : '',
  'TRACKING_ENABLED': prod
}
