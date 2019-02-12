import Link from 'next/link'
import React, { PureComponent } from 'react'
import { Query } from 'react-apollo'

import withNavigation from '../../components/navigation'
import FetchAlbumBySlugQuery from '../../queries/albums/by_slug.js'

import CheckoutModal from '../../components/checkout_modal'

import Button from '../../components/button'

import Page from '../../layouts/main.js'

class HomePage extends PureComponent {
  state = {
    openCheckoutModal: false
  }

  static async getInitialProps({ query }) {
    return { query }
  }

  toggleCheckoutModal = (bool) => {
    this.setState({
      openCheckoutModal: bool
    })
  }

  render() {
    const { album_slug, subdomain } = this.props.query
    const { openCheckoutModal } = this.state

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
                    <Button type='primary' text='Buy Album' icon='plus' onClick={() => this.toggleCheckoutModal(true)}/>
                    {
                      openCheckoutModal &&
                      <CheckoutModal />
                    }
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
