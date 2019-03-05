import React, { PureComponent } from 'react'
import { Query, Mutation } from 'react-apollo'

import FetchAlbumBySlugQuery from '../../queries/albums/by_slug.js'
import PurchaseAlbumMutation from '../../mutations/checkout/checkout_album.js'

import { AuthConsumer } from '../../contexts/auth'

import withNavigation from '../../components/navigation'
import CheckoutModal from '../../components/checkout_modal'
import CheckoutSuccess from '../../components/checkout_success'
import Button from '../../components/button'
import Spinner from '../../components/spinner'

import Page from '../../layouts/main.js'

import './checkout.css'

class CheckoutPage extends PureComponent {
  state = {
    checkoutErrors: [],
    checkoutSuccessful: false
  }

  static async getInitialProps({ query }) {
    return { query }
  }

  handleCreateToken = (album, purchaseAlbum, isAuthed) => ({
    token,
    email
  }) => {
    const variables = isAuthed
      ? {
          token: token.id,
          albumId: album.id
        }
      : {
          token: token.id,
          albumId: album.id,
          userEmail: email
        }

    purchaseAlbum({
      variables
    }).then(({ data }) => {
      if (data.checkoutAlbum.errors) {
        this.setState({
          checkoutErrors: data.checkoutAlbum.errors
        })
      } else {
        this.setState({
          checkoutSuccessful: true
        })
      }
    })
  }

  render() {
    const { album_slug, storefront_slug } = this.props.query
    const { checkoutSuccessful, checkoutErrors } = this.state

    return (
      <AuthConsumer>
        {({ isAuthed }) => (
          <Page className='bg-grey-lightest djn-checkoutPage'>
            <div className='container py-20'>
              <Query
                query={FetchAlbumBySlugQuery}
                variables={{ slug: album_slug }}
              >
                {({ data, loading }) => (
                  <Mutation mutation={PurchaseAlbumMutation}>
                    {(
                      purchaseAlbum,
                      { data: mutationData, loading, error }
                    ) => (
                      <>
                        {loading && <Spinner color='blue' />}

                        {checkoutErrors && Boolean(checkoutErrors.length) && (
                          <div className='error'>
                            {checkoutErrors.map(error => (
                              <p>{error.errorMessage}</p>
                            ))}
                          </div>
                        )}

                        {checkoutSuccessful && (
                          <div className='success-pane container limit-screen w-3/4'>
                            <div className='album-coverArtUrl'>
                              <img src={data.album.coverArtUrl} />
                            </div>
                            <div className='mx-8'>
                              <CheckoutSuccess album={data.album} />
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
                                <Button type='translucent' text='Download' icon='download' className='album-purchaseBtn' />
                              </div>
                            </div>
                          </div>
                        )}

                        {!checkoutSuccessful && !loading && !mutationData && (
                          <CheckoutModal
                            onCreateToken={this.handleCreateToken(
                              data.album,
                              purchaseAlbum,
                              isAuthed
                            )}
                            isAuthed={isAuthed}
                            album={data.album}
                          />
                        )}
                      </>
                    )}
                  </Mutation>
                )}
              </Query>
            </div>
          </Page>
        )}
      </AuthConsumer>
    )
  }
}

export default withNavigation(CheckoutPage)
