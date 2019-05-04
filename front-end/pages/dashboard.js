import withOnlyAuthenticated from '../lib/onlyAuthenticated'
import withNavigation from '../components/navigation'

import DashboardLayout from '../layouts/dashboard'

const DashboardPage = () => (
  <DashboardLayout type='dashboard'>
    {({me}) => (
      <div className='djn-dashboardPage'>
        <h2>Overview</h2>
      </div>
    )}
  </DashboardLayout>
)

export default withOnlyAuthenticated(
  withNavigation(DashboardPage)
)
