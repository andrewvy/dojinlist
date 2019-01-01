import { withRouter } from 'next/router'
import { AuthConsumer } from '../contexts/auth'
import onlyUnauthenticated from '../lib/onlyUnauthenticated'
import Register from '../components/register'
import Page from '../layouts/main.js'
import withNavigation from '../components/navigation'

const RegisterPage = (props) => {
  return (
    <Page>
      <Register />
    </Page>
  )
}

export default onlyUnauthenticated(
  withRouter(
    withNavigation(
      RegisterPage
    )
  )
)
