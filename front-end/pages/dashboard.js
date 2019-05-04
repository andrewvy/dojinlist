import { MeConsumer } from '../contexts/me.js'
import withOnlyAuthenticated from '../lib/onlyAuthenticated'
import Page from '../layouts/main.js'
import withNavigation from '../components/navigation'
import Spinner from '../components/spinner'

import './dashboard.css'

const DashboardPage = () => (
  <Page className='djn-dashboardPage max-vh'>
    <MeConsumer>
      {({isLoading, me}) => {
        if (isLoading) {
          return (
            <div className='container vertical-center'>
              <Spinner color='blue-darker' size='large' />
            </div>
          )
        } else {
          return (
            <div className='default-width mx-auto py-8'>
              <h2>Dashboard</h2>
              <div className='wrapper'>
                <nav className='djn-dashboardNavigation shadow'>
                  <div className='nav-item active'>
                    Your profile
                  </div>
                  <div className='nav-item'>
                    Your purchases
                  </div>
                </nav>
                <div className='content shadow'>
                  content here
                </div>
              </div>
            </div>
          )
        }
      }}
    </MeConsumer>
  </Page>
)

export default withOnlyAuthenticated(
  withNavigation(DashboardPage)
)
