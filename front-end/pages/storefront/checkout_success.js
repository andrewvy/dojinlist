import { Component } from 'react'
import { Query, Mutation } from 'react-apollo'

import FetchAlbumBySlugQuery from '../../queries/albums/by_slug'
import DownloadAlbumMutation from '../../mutations/download/download_album'

import { AuthConsumer } from '../../contexts/auth'

import CheckoutSuccess from '../../components/checkout_success'
import Button from '../../components/button'

import Page from '../../layouts/main.js'

import './checkout_success.css'

class CheckoutSuccessPage extends Component {
  static async getInitialProps({ query }) {
    return { query }
  }

  state = {
    selectedEncoding: 'MP3_320'
  }

  setEncoding = (ev) => {
    const selectedEncoding = ev.target.value

    this.setState({
      selectedEncoding
    })
  }

  downloadAlbum = (downloadAlbum, albumId, encoding) => {
    const variables = {
      download: {
        albumId,
        encoding
      }
    }

    downloadAlbum({
      variables
    }).then(({ data }) => {
      const { url, errors } = data.generateAlbumDownloadUrl

      if (errors) {
      } else {
        window.location.href = url;
      }
    })
  }

  render() {
    const { album_slug, username, transaction_id } = this.props.query
    const { selectedEncoding } = this.state

    return (
      <AuthConsumer>
        {({ isAuthed }) => (
          <Query query={FetchAlbumBySlugQuery} variables={{ slug: album_slug }}>
            {({ data, loading }) => (
              <Mutation mutation={DownloadAlbumMutation}>
                {(downloadAlbum) => (
                  <Page className='bg-grey-lightest djn-checkoutPageSuccess'>
                    <div className='container py-20'>
                      <div className='success-pane container limit-screen w-3/4'>
                        <div className='album-coverArtUrl'>
                          <img src={data.album.coverArtUrl} />
                        </div>
                        <div className='mx-8'>
                          <CheckoutSuccess
                            album={data.album}
                            transactionId={transaction_id}
                          />
                          <div className='download-format'>
                            Choose your download format
                            <select value={selectedEncoding} onChange={this.setEncoding}>
                              <option value='MP3_V0'>MP3-V0</option>
                              <option value='MP3_320'>MP3-320K</option>
                              <option value='MP3-128'>MP3-128K</option>
                              <option value='FLAC'>FLAC</option>
                            </select>
                            <Button
                              type='translucent'
                              text='Download'
                              icon='download'
                              className='album-purchaseBtn'
                              onClick={() => this.downloadAlbum(downloadAlbum, data.album.id, selectedEncoding)}
                            />
                          </div>
                        </div>
                      </div>
                    </div>
                  </Page>
                )}
              </Mutation>
            )}
          </Query>
        )}
      </AuthConsumer>
    )
  }
}

export default CheckoutSuccessPage
