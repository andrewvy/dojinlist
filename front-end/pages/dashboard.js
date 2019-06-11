import { Mutation } from 'react-apollo'

import withOnlyAuthenticated from '../lib/onlyAuthenticated'
import Uploader from '../components/uploader'
import Label from '../components/label'

import DashboardLayout from '../layouts/dashboard'

import UploadAvatarMutation from '../mutations/me/upload_avatar'

const DashboardPage = () => (
  <DashboardLayout type='dashboard'>
    {({ me }) => (
      <div className='djn-dashboardPage'>
        <h2>Overview</h2>
        <div className='avatar'>
          <Mutation mutation={UploadAvatarMutation} errorPolicy='all'>
            {(performUploadAvatar, { data }) => (
              <div className='avatar'>
                <Label>Avatar</Label>
                <Uploader
                  imageUrl={
                    (data && data.uploadAvatar && data.uploadAvatar.avatar) ||
                    me.avatar
                  }
                  performUpload={file =>
                    performUploadAvatar({
                      variables: { avatar: file }
                    })
                  }
                />
              </div>
            )}
          </Mutation>
        </div>
        <div className='username'>
          <Label>Username</Label>
          <input
            type='text'
            placeholder='Username'
            value={me.username}
            disabled
          />
        </div>
        <div className='email'>
          <Label>Email</Label>
          <input type='text' placeholder='Email' value={me.email} disabled />
        </div>
      </div>
    )}
  </DashboardLayout>
)

export default withOnlyAuthenticated(DashboardPage)
