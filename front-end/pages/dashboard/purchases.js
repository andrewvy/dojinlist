import withOnlyAuthenticated from '../../lib/onlyAuthenticated'

import DashboardLayout from '../../layouts/dashboard'

const PurchasesPage = () => (
  <DashboardLayout type='purchases'>
    {({me}) => (
      <div className='djn-purchasesPage'>
        <h2>Your purchases</h2>
      </div>
    )}
  </DashboardLayout>
)

export default withOnlyAuthenticated(
  PurchasesPage
)
