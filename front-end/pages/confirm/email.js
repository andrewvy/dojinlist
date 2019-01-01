import { withRouter } from 'next/router'
import { Mutation } from 'react-apollo'
import Link from 'next/link'
import parseQueryString from 'qs/lib/parse'

import Page from '../../layouts/main.js'
import Spinner from '../../components/spinner'

import ConfirmEmailMutation from '../../mutations/accounts/confirm_email.js'

import withNavigation from '../../components/navigation'

class ConfirmEmail extends React.Component {
  state = {
    loading: true,
  }

  componentDidMount() {
    if (process.browser) {
      const { router, confirmEmail } = this.props
      const { asPath, pathname } = router

      const querystring = asPath.substring(pathname.length + 1, asPath.length)
      const query = parseQueryString(querystring)

      const { token } = query

      confirmEmail({
        variables: {
          token
        }
      }).finally(() => {
        this.setState({
          loading: false
        })
      })
    }
  }

  render() {
    const { loading } = this.state
    const { data } = this.props

    if (loading) {
      return (
        <Page>
          <div className='container vertical-center'>
            <Spinner color='blue-darker' />
          </div>
        </Page>
      )
    } else if (data) {
      return (
        <Page>
          <div className='container vertical-center'>
            Email confirmed! <Link href='/login'><a>Click here to login.</a></Link>
          </div>
        </Page>
      )
    } else {
      return (
        <Page>
          <div className='container vertical-center'>Could not confirm your email..</div>
        </Page>
      )
    }
  }
}

const Wrapper = (props) => (
  <Mutation mutation={ConfirmEmailMutation}>
    {(confirmEmail, {data, loading}) => (
      <ConfirmEmail
        confirmEmail={confirmEmail}
        data={data}
        loading={loading}
        {...props}
      />
    )}
  </Mutation>
)

export default withRouter(withNavigation(Wrapper))
