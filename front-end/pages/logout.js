import { withRouter } from 'next/router'
import { AuthConsumer } from '../contexts/auth'
import onlyAuthenticated from '../lib/onlyAuthenticated'
import Login from '../components/login'

import Page from '../layouts/main.js'

const LogoutPage = (props) => {
  const { logout, router, isAuthed } = props

  if (isAuthed) {
    logout()
    router.push('/')
  }

  return (
    <div>
      Returning to logout page.
    </div>
  )
}

const Wrapper = (pageProps) => (
  <Page>
    <AuthConsumer>
      {({...props}) => (
        <LogoutPage
          {...props}
          {...pageProps}
        />
      )}
    </AuthConsumer>
  </Page>
)

export default onlyAuthenticated(
  withRouter(Wrapper)
)
