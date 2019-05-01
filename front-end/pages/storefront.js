import React, { PureComponent } from 'react'
import { Query } from 'react-apollo'
import ErrorPage from 'next/error'

import withNavigation from '../components/navigation'

import FetchStorefrontQuery from '../queries/storefront/storefront.js'
import FetchAlbumsByStorefrontId from '../queries/albums/by_storefront_id.js'

import AlbumThumbnailGrid from '../components/album_thumbnail_grid'

import Page from '../layouts/main.js'

import './storefront.css'

const transformAlbums = edge => edge.node

class HomePage extends PureComponent {
  static async getInitialProps({ query }) {
    return { query }
  }

  render() {
    const { storefront_slug } = this.props.query

    return (
      <Page>
        <div className='container'>
          <Query
            query={FetchStorefrontQuery}
            variables={{ slug: storefront_slug }}
          >
            {({ data, loading, error }) => (
              <div>
                {!loading && data && (
                  <>
                    <div className='djn-storefrontHeader'>
                      <div className='djn-storefrontBanner'>
                        <img src={data.storefront.bannerImage} />
                      </div>
                      <div className='djn-storefrontAvatar'>
                        <div className='avatar-container'>
                          <img src={data.storefront.avatarImage} />
                        </div>
                        <div className='display-name'>
                          {data.storefront.displayName}
                        </div>
                      </div>
                    </div>

                    <div className='djn-storefrontPage'>
                      <Query
                        query={FetchAlbumsByStorefrontId}
                        variables={{
                          storefrontId: data.storefront.id,
                          first: 10
                        }}
                      >
                        {({ data, loading, error }) => (
                          <div className='albums'>
                            <AlbumThumbnailGrid
                              albums={data.albums.edges.map(transformAlbums)}
                              storefront_slug={storefront_slug}
                            />
                          </div>
                        )}
                      </Query>
                    </div>
                  </>
                )}

                {error && <ErrorPage statusCode={404} />}
              </div>
            )}
          </Query>
        </div>
      </Page>
    )
  }
}

export default withNavigation(HomePage)
