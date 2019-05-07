import withOnlyAuthenticated from '../lib/onlyAuthenticated'
import withNavigation from '../components/navigation'
import AvatarUploader from '../components/avatar_uploader'
import Label from '../components/label'

import DashboardLayout from '../layouts/dashboard'

const DashboardPage = () => (
  <DashboardLayout type='dashboard'>
    {({me}) => (
      <div className='djn-dashboardPage'>
        <h2>Overview</h2>
        <div className='Avatar'>
          <Label>Avatar</Label>
          <AvatarUploader />
        </div>
        <div className='username'>
          <Label>Username</Label>
          <input type='text' placeholder='Username' value={me.username} disabled/>
        </div>
        <div className='email'>
          <Label>Email</Label>
          <input type='text' placeholder='Email' value={me.email} disabled/>
        </div>
      </div>
    )}
  </DashboardLayout>
)

export default withOnlyAuthenticated(
  withNavigation(DashboardPage)
)
