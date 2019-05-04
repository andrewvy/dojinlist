import { MeConsumer } from '../contexts/me.js'
import Page from './main.js'
import Spinner from '../components/spinner'

import { Link } from '../routes.js'

import './dashboard.css'

const DashboardLayout = ({type, children}) => (
  <Page className='djn-dashboardLayout max-vh'>
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
                  <Link route='dashboard'>
                    <a className={`nav-item ${type === 'dashboard' ? 'active': ''}`}>
                      Your profile
                    </a>
                  </Link>
                  <Link route='dashboard_purchases'>
                    <a className={`nav-item ${type === 'purchases' ? 'active': ''}`}>
                      Your purchases
                    </a>
                  </Link>
                </nav>
                <div className='content shadow rounded'>
                  {
                    children({me})
                  }
                </div>
              </div>
            </div>
          )
        }
      }}
    </MeConsumer>
  </Page>
)

export default DashboardLayout
