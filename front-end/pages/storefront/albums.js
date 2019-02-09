import React, { PureComponent } from 'react'
import { Query } from 'react-apollo'

import FetchAlbumBySlugQuery from '../../queries/albums/by_slug.js'

import Page from '../../layouts/main.js'

class HomePage extends PureComponent {
  static async getInitialProps({ query }) {
    return { query }
  }

  render() {
    const { album_slug } = this.props.query

    console.log(this.props.query)

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

export default HomePage
