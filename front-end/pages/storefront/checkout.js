import { Link } from '../../routes.js'
import React, { PureComponent } from 'react'
import { Query, Mutation } from 'react-apollo'

import FetchAlbumBySlugQuery from '../../queries/albums/by_slug.js'
import PurchaseAlbumMutation from '../../mutations/checkout/checkout_album.js'

import withNavigation from '../../components/navigation'
import CheckoutModal from '../../components/checkout_modal'

import Button from '../../components/button'
import Page from '../../layouts/main.js'

class CheckoutPage extends PureComponent {
  static async getInitialProps({ query }) {
    return { query }
  }

  handleCreateToken = (album, purchaseAlbum) => ({token, email}) => {
    purchaseAlbum({
      variables: {
        token: token.id,
        albumId: album.id,
        userEmail: email
      }
    }).then(({ data }) => {
      if (!data.checkoutAlbum.errors) {
      }
    })
  }

  render() {
    const { album_slug, storefront_slug } = this.props.query

    return (
      <Page>
        <div className='container py-20'>
          <Query query={FetchAlbumBySlugQuery} variables={{slug: album_slug}} >
            {({data, loading}) => (
              <Mutation mutation={PurchaseAlbumMutation}>
                {(purchaseAlbum, { data: mutationData, loading, error }) => (
                  <>
                    <Link
                      route='album'
                      params={{storefront_slug, album_slug}}
                    >
                      Back to album
                    </Link>
                    {
                      loading &&
                      <Spinner color='blue' />
                    }

                    {
                      !loading &&
                      !mutationData &&
                      data &&
                      <CheckoutModal onCreateToken={this.handleCreateToken(data.album, purchaseAlbum)}/>
                    }
                  </>
                )}
              </Mutation>
            )}
          </Query>
        </div>
      </Page>
    )
  }
}

export default withNavigation(CheckoutPage)
