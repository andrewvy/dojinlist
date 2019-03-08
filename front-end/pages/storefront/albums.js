import { Link } from '../../routes.js'
import React, { PureComponent } from 'react'
import { Query, Mutation } from 'react-apollo'

import withNavigation from '../../components/navigation'
import AlbumTracklist from '../../components/album_tracklist'

import FetchAlbumBySlugQuery from '../../queries/albums/by_slug.js'
import PurchaseAlbumMutation from '../../mutations/checkout/checkout_album.js'
import DownloadTrackMutation from '../../mutations/download/download_track.js'

import { PlayerConsumer } from '../../contexts/player'

import Button from '../../components/button'
import Spinner from '../../components/spinner'
import AlbumCover from '../../components/album_cover'

import Page from '../../layouts/main.js'

import './albums.css'

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
            <div className='container djn-storefrontAlbumsPage'>
              <Query query={FetchAlbumBySlugQuery} variables={{slug: album_slug}} >
                {({data, loading}) => (
                  <div>
                    {
                      !loading && data &&
                      <div>
                        <div className='album'>
                          <div className='album-coverArtUrl'>
                            <AlbumCover album={data.album} />
                          </div>
                          <div className='album-right'>
                            <div className='album-header'>
                              <span className='album-title'>{data.album.title}</span>
                              <Link
                                route='album_checkout'
                                params={{storefront_slug, album_slug}}
                              >
                                <Button type='primary' text='Buy Album' icon='plus' className='album-purchaseBtn'/>
                              </Link>
                            </div>

                            <Mutation mutation={DownloadTrackMutation}>
                              {(downloadTrack, { data: mutationData, loading, error }) => (
                                <AlbumTracklist album={data.album} onTrackClick={(track) => { this.streamTrack(downloadTrack, track, setPlayerTrack) } }/>
                              )}
                            </Mutation>
                          </div>
                        </div>
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
