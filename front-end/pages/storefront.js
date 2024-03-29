import React, { PureComponent } from 'react'
import { Query } from 'react-apollo'
import ErrorPage from 'next/error'
import classnames from 'classnames'

import FetchStorefrontQuery from '../queries/storefront/storefront.js'
import FetchAlbumsByStorefrontId from '../queries/albums/by_storefront_id.js'

import AlbumThumbnailGrid from '../components/album_thumbnail_grid'
import Pill from '../components/pill'

import Page from '../layouts/main.js'

import './storefront.css'

const transformAlbums = edge => edge.node

class HomePage extends PureComponent {
  static async getInitialProps({ query }) {
    return { query }
  }

  render() {
    const { username } = this.props.query

    return (
      <Page>
        <div className='djn-storefrontPageContainer'>
          <div className='djn-storefrontPage container'>
            <Query query={FetchStorefrontQuery} variables={{ username }}>
              {({ data, loading, error }) => (
                <div>
                  {!loading && data && (
                    <>
                      <div className='djn-storefrontHeader'>
                        <div
                          className={classnames('djn-storefrontBanner', {
                            'is-empty': !Boolean(data.storefront.bannerImage)
                          })}
                        >
                          <img src={data.storefront.bannerImage} />
                        </div>
                        <div
                          className={classnames('djn-storefrontAvatar', {
                            'is-empty': !Boolean(data.storefront.avatarImage)
                          })}
                        >
                          <div className='avatar-container'>
                            <img src={data.storefront.avatarImage} />
                          </div>
                          <div className='display-name'>
                            {data.storefront.displayName}
                          </div>
                        </div>
                      </div>

                      <div className='content'>
                        <div className='storefront-description'>
                          {data.storefront.description}
                        </div>
                        <Query
                          query={FetchAlbumsByStorefrontId}
                          variables={{
                            storefrontId: data.storefront.id,
                            first: 10
                          }}
                        >
                          {({ data, loading, error }) => (
                            <div className='albums'>
                              {data.albums.edges.length > 0 ? (
                                <AlbumThumbnailGrid
                                  albums={data.albums.edges.map(
                                    transformAlbums
                                  )}
                                  username={username}
                                />
                              ) : (
                                <div className='empty'>
                                  No albums are here yet, check back later!
                                </div>
                              )}
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
        </div>
      </Page>
    )
  }
}

export default HomePage
