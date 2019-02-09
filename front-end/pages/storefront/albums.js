import Link from 'next/link'
import React, { PureComponent } from 'react'
import { Query } from 'react-apollo'

import withNavigation from '../../components/navigation'
import FetchAlbumBySlugQuery from '../../queries/albums/by_slug.js'

import Page from '../../layouts/main.js'

import {Elements} from 'react-stripe-elements';
import {CardElement} from 'react-stripe-elements';

const Checkout = () => (
  <Elements>
    <form onSubmit={() => {}}>
      <label>
        Card details
          <CardElement style={{base: {fontSize: '18px'}}} />
      </label>
    </form>
  </Elements>
)

class HomePage extends PureComponent {
  static async getInitialProps({ query }) {
    return { query }
  }

  render() {
    const { album_slug, subdomain } = this.props.query

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
                    <Checkout />
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
