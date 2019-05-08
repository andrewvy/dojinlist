import { Mutation } from 'react-apollo'

import UploadAvatarMutation from '../../mutations/storefronts/upload_avatar'
import UploadBannerMutation from '../../mutations/storefronts/upload_banner'

import withOnlyAuthenticated from '../../lib/onlyAuthenticated'
import withNavigation from '../../components/navigation'
import Uploader from '../../components/uploader'
import Label from '../../components/label'
import Button from '../../components/button'
import Description from '../../components/description'

import DashboardLayout from '../../layouts/dashboard'

const StorefrontPage = () => (
  <DashboardLayout type='storefront'>
    {({ me }) => (
      <div className='djn-dashboardStorefrontPage'>
        <h2>Your storefront</h2>
        <Mutation mutation={UploadAvatarMutation} errorPolicy='all'>
          {(performUploadAvatar, { data }) => (
            <div className='avatar'>
              <Label>Avatar</Label>
              <Uploader
                imageUrl={
                  (data &&
                    data.uploadStorefrontAvatar &&
                    data.uploadStorefrontAvatar.avatarImage) ||
                  me.storefront.avatarImage
                }
                performUpload={file =>
                  performUploadAvatar({
                    variables: { avatar: file, storefrontId: me.storefront.id }
                  })
                }
              />
            </div>
          )}
        </Mutation>
        <Mutation mutation={UploadBannerMutation} errorPolicy='all'>
          {(performUploadBanner, { data }) => (
            <div className='banner'>
              <Label>Banner</Label>
              <Uploader
                imageUrl={
                  (data &&
                    data.uploadStorefrontBanner &&
                    data.uploadStorefrontBanner.bannerImage) ||
                  me.storefront.bannerImage
                }
                performUpload={file =>
                  performUploadBanner({
                    variables: { banner: file, storefrontId: me.storefront.id }
                  })
                }
              />
            </div>
          )}
        </Mutation>

        <fieldset>
          <Label>Stripe</Label>
          <Description>
            A connected Stripe account is needed in order to be paid from album
            purchases.
          </Description>

          {me.stripeAccount && me.stripeAccount.stripeUserId ? (
            <Button type='secondary' text='Connected to Stripe' disabled />
          ) : (
            <Button type='secondary' icon='plus' text='Connect to Stripe' />
          )}
        </fieldset>
      </div>
    )}
  </DashboardLayout>
)

export default withOnlyAuthenticated(withNavigation(StorefrontPage))
