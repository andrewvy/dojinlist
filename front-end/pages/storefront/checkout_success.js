import { PureComponent } from 'react'
import { Query, Mutation } from 'react-apollo'

import FetchAlbumBySlugQuery from '../../queries/albums/by_slug.js'

import { AuthConsumer } from '../../contexts/auth'

import withNavigation from '../../components/navigation'
import CheckoutSuccess from '../../components/checkout_success'
import Button from '../../components/button'

import Page from '../../layouts/main.js'

import './checkout_success.css'

class CheckoutSuccessPage extends PureComponent {
  static async getInitialProps({ query }) {
    return { query }
  }

  render() {
    const { album_slug, storefront_slug, transaction_id } = this.props.query

    return (
      <AuthConsumer>
        {({ isAuthed }) => (
          <Query query={FetchAlbumBySlugQuery} variables={{ slug: album_slug }}>
            {({ data, loading }) => (
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
                        <select>
                          <option>MP3-V0</option>
                          <option>MP3-320K</option>
                          <option>MP3-128K</option>
                          <option>FLAC</option>
                          <option>AIFF</option>
                          <option>WAV</option>
                        </select>
                        <Button
                          type='translucent'
                          text='Download'
                          icon='download'
                          className='album-purchaseBtn'
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </Page>
            )}
          </Query>
        )}
      </AuthConsumer>
    )
  }
}

export default withNavigation(CheckoutSuccessPage)
