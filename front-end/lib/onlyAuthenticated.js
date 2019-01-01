import { AuthConsumer } from '../contexts/auth'
import { withRouter } from 'next/router'
import React from 'react'

class OnlyAuthenticated extends React.Component {
  state = {
    isLoaded: true
  }

  componentDidMount() {
    const { isAuthed, router } = this.props


    if (!isAuthed) {
      router.replace('/login')

      this.setState({
        isLoaded: false
      })
    }
  }

  render() {
    const { children } = this.props
    const { isLoaded } = this.state

    if (isLoaded) {
      return (
        <>
          {children}
        </>
      )
    } else {
      <div>
        Loading...
      </div>
    }
  }
}

const Wrapper = withRouter((props) => (
  <OnlyAuthenticated
    {...props}
  />
))

const withOnlyAuthenticated = (ProtectedComponent) => (props) => {
  return (
    <AuthConsumer>
      {({isAuthed}) => (
        <Wrapper isAuthed={isAuthed}>
          <ProtectedComponent {...props} />
        </Wrapper>
      )}
    </AuthConsumer>
  )
}

export default withOnlyAuthenticated
