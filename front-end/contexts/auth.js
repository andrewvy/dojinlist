import React from 'react'

import { getToken, setToken } from '../lib/token'

const AuthContext = React.createContext()

const isActiveAuthToken = (authToken) => {
  if (authToken && authToken.length) {
    let currentTime = Date.now() / 1000
    let payload = JSON.parse(window.atob(authToken.split('.')[1]))

    return currentTime < payload.exp
  } else {
    return false
  }
}

class AuthProvider extends React.Component {
  state = {
    isAuthed: false
  }

  constructor(props) {
    super(props)

    if (!process.browser) {
      return
    }

    const token = getToken()
    const hasActiveAuthToken = isActiveAuthToken(token)

    const isAuthed = hasActiveAuthToken

    this.state.isAuthed = isAuthed

    if (!isAuthed) {
      this.state.isAuthed = false
    }
  }

  login = (token) => {
    const hasActiveAuthToken = isActiveAuthToken(token)
    const isAuthed = hasActiveAuthToken

    setToken(token)

    if (isAuthed) {
      this.setState({
        isAuthed: isAuthed
      })
    }
  }

  logout = () => {
    setToken(null)

    this.setState({
      isAuthed: false
    })
  }

  render() {
    return (
      <AuthContext.Provider
        value={{
          isAuthed: this.state.isAuthed,
          login: this.login,
          logout: this.logout
        }}
      >
        {this.props.children}
      </AuthContext.Provider>
    )
  }
}

const AuthConsumer = AuthContext.Consumer

export { AuthProvider, AuthConsumer }
