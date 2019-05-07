import { Mutation } from 'react-apollo'

import UploadAvatarMutation from '../../mutations/storefronts/upload_avatar'
import UploadBannerMutation from '../../mutations/storefronts/upload_banner'

import withOnlyAuthenticated from '../../lib/onlyAuthenticated'
import withNavigation from '../../components/navigation'
import Uploader from '../../components/uploader'
import Label from '../../components/label'

import DashboardLayout from '../../layouts/dashboard'

const StorefrontPage = () => (
  <DashboardLayout type='storefront'>
    {({me}) => (
      <div className='djn-storefrontPage'>
        <h2>Your storefront</h2>
        <Mutation mutation={UploadAvatarMutation} errorPolicy='all'>
          {(performUploadAvatar, { data } ) => (
            <div className='avatar'>
              <Label>Avatar</Label>
              <Uploader
                imageUrl={(data && data.uploadStorefrontAvatar && data.uploadStorefrontAvatar.avatarImage) || me.storefront.avatarImage}
                performUpload={(file) => performUploadAvatar({variables: {avatar: file, storefrontId: me.storefront.id}})}
              />
            </div>
          )}
        </Mutation>
        <Mutation mutation={UploadBannerMutation} errorPolicy='all'>
          {(performUploadBanner, { data } ) => (
            <div className='banner'>
              <Label>Banner</Label>
              <Uploader
                imageUrl={(data && data.uploadStorefrontBanner && data.uploadStorefrontBanner.bannerImage) || me.storefront.bannerImage}
                performUpload={(file) => performUploadBanner({variables: {banner: file, storefrontId: me.storefront.id}})}
              />
            </div>
          )}
        </Mutation>
      </div>
    )}
  </DashboardLayout>
)

export default withOnlyAuthenticated(
  withNavigation(StorefrontPage)
)
