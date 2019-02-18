import React, { PureComponent } from 'react'
import { Query } from 'react-apollo'

import withNavigation from '../components/navigation'

import FetchStorefrontQuery from '../queries/storefront/storefront.js'
import FetchAlbumsByStorefrontId from '../queries/albums/by_storefront_id.js'

import AlbumThumbnailGrid from '../components/album_thumbnail_grid'

import Page from '../layouts/main.js'

const transformAlbums = (edge) => (edge.node)

class HomePage extends PureComponent {
  static async getInitialProps({ query }) {
    return { query }
  }

  render() {
    const { storefront_slug } = this.props.query

    return (
      <Page>
        <div className='container'>
          <Query query={FetchStorefrontQuery} variables={{slug: storefront_slug}}>
            {({data, loading, error}) => (
              <div>
                {loading && <div>Loading</div>}
                {
                  !loading && data &&
                    <div>
                      <p>Display Name: {data.storefront.display_name}</p>
                      <p>Description: {data.storefront.description}</p>
                      <Query query={FetchAlbumsByStorefrontId} variables={{storefrontId: data.storefront.id, first: 10}}>
                        {({data, loading, error}) => (
                          <div className='albums'>
                            <AlbumThumbnailGrid albums={data.albums.edges.map(transformAlbums)}/>
                          </div>
                        )}
                      </Query>
                    </div>
                }

                {
                  error &&
                    <div>
                    Error
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
