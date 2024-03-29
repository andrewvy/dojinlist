import React from 'react'
import { Query } from 'react-apollo'

import MeQuery from '../queries/me.js'
import { AuthConsumer } from '../contexts/auth.js'

const MeContext = React.createContext()

class MeProvider extends React.Component {
  render() {
    const { isAuthed } = this.props

    return (
      <Query query={MeQuery} skip={!isAuthed} errorPolicy='ignore'>
        {({ loading, data, error }) => (
          <MeContext.Provider
            value={{
              isLoading: loading,
              me: data && data.me
            }}
          >
            {this.props.children}
          </MeContext.Provider>
        )}
      </Query>
    )
  }
}

const Wrapper = props => (
  <AuthConsumer>
    {({ isAuthed }) => <MeProvider {...props} isAuthed={isAuthed} />}
  </AuthConsumer>
)

const MeConsumer = MeContext.Consumer

export { MeConsumer, Wrapper as MeProvider }
