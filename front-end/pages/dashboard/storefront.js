import { Mutation } from 'react-apollo'

import UploadAvatarMutation from '../../mutations/storefronts/upload_avatar'
import UploadBannerMutation from '../../mutations/storefronts/upload_banner'

import withOnlyAuthenticated from '../../lib/onlyAuthenticated'
import { withNamespaces } from '../../lib/i18n'

import Uploader from '../../components/uploader'
import Label from '../../components/label'
import Button from '../../components/button'
import Description from '../../components/description'

import DashboardLayout from '../../layouts/dashboard'

const StorefrontPage = ({ t }) => (
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
            {t('stripe-description')}
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

const Wrapper = withOnlyAuthenticated(StorefrontPage)

Wrapper.getInitialProps = async () => {
  return {
    namespacesRequired: ['dashboard'],
  }
}

export default withNamespaces('dashboard')(Wrapper)
