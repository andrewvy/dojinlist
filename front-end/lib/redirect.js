// lib/utils/redirect.js
import Router from 'next/router'

// redirect helper function to be used in getInitialProps
export default (res, url) => {
  // res is only available if server-side
  if (res) {
    res.writeHead(302, { location: url })
    res.end()
  } else {
    Router.push(url)
  }
}
