import Link from 'next/link'
import React, { PureComponent } from 'react'
import { Query, Mutation } from 'react-apollo'

import withNavigation from '../../components/navigation'
import FetchAlbumBySlugQuery from '../../queries/albums/by_slug.js'
import PurchaseAlbumMutation from '../../mutations/checkout/checkout_album.js'

import CheckoutModal from '../../components/checkout_modal'
import Button from '../../components/button'
import Spinner from '../../components/spinner'

import Page from '../../layouts/main.js'

class HomePage extends PureComponent {
  state = {
    openCheckoutModal: false,
    purchasedAlbum: false
  }

  static async getInitialProps({ query }) {
    return { query }
  }

  toggleCheckoutModal = (bool) => {
    this.setState({
      openCheckoutModal: bool
    })
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
        this.setState({
          purchasedAlbum: true
        })
      }
    })
  }

  render() {
    const { album_slug, subdomain } = this.props.query
    const { openCheckoutModal, purchasedAlbum } = this.state

    return (
      <Page>
        <div className='container'>
          <Query query={FetchAlbumBySlugQuery} variables={{slug: album_slug}} >
            {({data, loading}) => (
              <div>
                {
                  !loading && data &&
                  <div>
                    <p>Album Slug: {album_slug}</p>
                    <p>Album Title: {data.album.title}</p>

                    {
                      data.album.tracks.length > 0 &&
                      <ul>
                        {data.album.tracks.map((track, i) => <li key={i}>{track.title}</li>)}
                      </ul>
                    }

                    {
                      !purchasedAlbum &&
                      <Button type='primary' text='Buy Album' icon='plus' onClick={() => this.toggleCheckoutModal(true)}/>
                    }

                    {
                      purchasedAlbum &&
                      <Button type='translucent' text='Download' icon='download' onClick={() => {}}/>
                    }

                    <Mutation mutation={PurchaseAlbumMutation}>
                      {(purchaseAlbum, { data: mutationData, loading, error }) => (
                        <>
                          {
                            loading &&
                            <Spinner color='blue' />
                          }

                          {
                            openCheckoutModal &&
                            !loading &&
                            !mutationData &&
                            <CheckoutModal onCreateToken={this.handleCreateToken(data.album, purchaseAlbum)}/>
                          }
                        </>
                      )} 
                    </Mutation>
                    <Link href={`/storefront?subdomain=${subdomain}`} as='/'>Storefront</Link>
                  </div>
                }
              </div>
            )}
          </Query>
        </div>
      </Page>
    )
  }
}

export default withNavigation(HomePage)
