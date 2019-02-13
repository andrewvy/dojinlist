import Link from 'next/link'
import React, { PureComponent } from 'react'
import { Query, Mutation } from 'react-apollo'

import withNavigation from '../../components/navigation'
import FetchAlbumBySlugQuery from '../../queries/albums/by_slug.js'
import PurchaseAlbumMutation from '../../mutations/checkout/checkout_album.js'
import DownloadTrackMutation from '../../mutations/download/download_track.js'

import CheckoutModal from '../../components/checkout_modal'
import Button from '../../components/button'
import Spinner from '../../components/spinner'
import Player from '../../components/player/wrapper.js'

import Page from '../../layouts/main.js'

class HomePage extends PureComponent {
  state = {
    openCheckoutModal: false,
    purchasedAlbum: false,
    currentTrack: {},
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

  streamTrack = (downloadTrack, track) => {
    const variables = {
      download: {
        trackId: track.id,
        encoding: "MP3_128"
      }
    }

    downloadTrack({ variables }).then((response) => {
      this.setState({
        currentTrack: {
          name: track.title,
          src: response.data["generateTrackDownloadUrl"].url
        }
      })
    })
  }

  render() {
    const { album_slug, subdomain } = this.props.query
    const { openCheckoutModal, purchasedAlbum, currentTrack } = this.state

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

                    <Mutation mutation={DownloadTrackMutation}>
                      {(downloadTrack, { data: mutationData, loading, error }) => (
                        <div>
                          {
                            data.album.tracks.length > 0 &&
                            <ul>
                              {data.album.tracks.map((track, i) => (
                                <li key={track.id}>
                                  <span>{track.title}</span>
                                  <Button type='primary' text='Stream' onClick={() => { this.streamTrack(downloadTrack, track) }} />
                                </li>
                              ))}
                            </ul>
                          }
                        </div>
                      )}
                    </Mutation>

                    <Player track={currentTrack} album={{}} />

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
