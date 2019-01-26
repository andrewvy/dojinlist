import { MeConsumer } from '../contexts/me.js'
import withOnlyAuthenticated from '../lib/onlyAuthenticated'
import Page from '../layouts/main.js'
import AvatarUploader from '../components/avatar_uploader'
import UserDetails from '../components/user_details'
import Spinner from '../components/spinner'
import ProfileNavigation from '../components/profile_navigation'
import withNavigation from '../components/navigation'

const ProfilePage = () => (
  <Page>
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
            <div className='limit-screen mx-auto'>
              <UserDetails user={me} />
              <ProfileNavigation />
              <div className='container'>
                <label>Avatar</label>
                <AvatarUploader />
              </div>
            </div>
          )
        }
      }}
    </MeConsumer>
  </Page>
)

export default withOnlyAuthenticated(
  withNavigation(ProfilePage)
)
