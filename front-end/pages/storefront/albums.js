import { Link } from '../../routes.js'
import React, { PureComponent } from 'react'
import { Query, Mutation } from 'react-apollo'

import withNavigation from '../../components/navigation'
import FetchAlbumBySlugQuery from '../../queries/albums/by_slug.js'
import PurchaseAlbumMutation from '../../mutations/checkout/checkout_album.js'
import DownloadTrackMutation from '../../mutations/download/download_track.js'

import { PlayerConsumer } from '../../contexts/player'

import Button from '../../components/button'
import Spinner from '../../components/spinner'

import Page from '../../layouts/main.js'

class HomePage extends PureComponent {
  state = {
    currentTrack: {},
  }

  static async getInitialProps({ query }) {
    return { query }
  }

  streamTrack = (downloadTrack, track, setTrack) => {
    const variables = {
      download: {
        trackId: track.id,
        encoding: "MP3_128"
      }
    }

    downloadTrack({ variables }).then((response) => {
      setTrack({
          name: track.title,
          src: response.data["generateTrackDownloadUrl"].url
      })
    })
  }

  render() {
    const { album_slug, storefront_slug } = this.props.query
    const { currentTrack } = this.state

    return (
      <PlayerConsumer>
        {({setTrack: setPlayerTrack}) => (
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

                        <Mutation mutation={DownloadTrackMutation}>
                          {(downloadTrack, { data: mutationData, loading, error }) => (
                            <div>
                              {
                                data.album.tracks.length > 0 &&
                                <ul>
                                  {data.album.tracks.map((track, i) => (
                                    <li key={track.id}>
                                      <span>{track.title}</span>
                                      <Button type='primary' text='Stream' onClick={() => { this.streamTrack(downloadTrack, track, setPlayerTrack) }} />
                                    </li>
                                  ))}
                                </ul>
                              }
                            </div>
                          )}
                        </Mutation>

                        <Link
                          route='album_checkout'
                          params={{storefront_slug, album_slug}}
                        >
                          <Button type='primary' text='Buy Album' icon='plus'/>
                        </Link>
                      </div>
                    }
                  </div>
                )}
              </Query>
            </div>
          </Page>
        )}
      </PlayerConsumer>
    )
  }
}

export default withNavigation(HomePage)
