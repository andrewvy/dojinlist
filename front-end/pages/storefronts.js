import { MeConsumer } from '../contexts/me.js'

import { Link } from '../routes.js'

import withOnlyAuthenticated from '../lib/onlyAuthenticated'

import Page from '../layouts/main.js'

import withNavigation from '../components/navigation'
import Spinner from '../components/spinner'

const Storefronts = () => (
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
            <div className='limit-screen mx-auto py-16'>
              Your storefronts

              {
                me.storefronts.map((storefront) => (
                  <div>
                    <Link
                      route='storefront'
                      params={{storefront_slug: storefront.slug}}
                      >
                      <a>{storefront.slug}</a>
                    </Link>
                  </div>
                ))
              }
            </div>
          )
        }
      }}
    </MeConsumer>
  </Page>
)

export default withOnlyAuthenticated(
  withNavigation(Storefronts)
)
