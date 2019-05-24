import { withRouter } from 'next/router'

import { AuthConsumer } from '../contexts/auth'
import onlyUnauthenticated from '../lib/onlyUnauthenticated'
import Login from '../components/login'
import Page from '../layouts/main.js'

const LoginPage = props => {
  const { login } = props

  return (
    <Page>
      <Login login={login} />
    </Page>
  )
}

const Wrapper = pageProps => (
  <AuthConsumer>
    {({ ...props }) => <LoginPage {...props} {...pageProps} />}
  </AuthConsumer>
)

export default onlyUnauthenticated(withRouter(Wrapper))
