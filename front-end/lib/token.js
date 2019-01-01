const getToken = () => {
  if (!process.browser) return
  return JSON.parse(window.localStorage.getItem('DJNLIST_TOKEN'))
}

const setToken = (token) => {
  if (!process.browser) return
  return window.localStorage.setItem('DJNLIST_TOKEN', JSON.stringify(token))
}

export {
  getToken,
  setToken
}
