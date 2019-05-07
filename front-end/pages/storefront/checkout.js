import React, { PureComponent } from 'react'
import { Query, Mutation } from 'react-apollo'

import { Router } from '../../routes.js'

import FetchAlbumBySlugQuery from '../../queries/albums/by_slug.js'
import PurchaseAlbumMutation from '../../mutations/checkout/checkout_album.js'

import { AuthConsumer } from '../../contexts/auth'

import withNavigation from '../../components/navigation'
import CheckoutModal from '../../components/checkout_modal'
import Button from '../../components/button'
import Spinner from '../../components/spinner'

import Page from '../../layouts/main.js'

class CheckoutPage extends PureComponent {
  state = {
    checkoutErrors: []
  }

  static async getInitialProps({ query }) {
    return { query }
  }

  handleCreateToken = (album, purchaseAlbum, isAuthed) => ({
    token,
    email
  }) => {
    const { album_slug, username } = this.props.query

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
      const { transactionId, errors } = data.checkoutAlbum

      if (errors) {
        this.setState({
          checkoutErrors: data.checkoutAlbum.errors
        })
      } else {
        Router.pushRoute('album_checkout_success', {
          album_slug,
          username,
          transaction_id: transactionId
        })
      }
    })
  }

  render() {
    const { album_slug, username } = this.props.query
    const { checkoutErrors } = this.state

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
                      { data: checkoutData, loading, error }
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

                        {!loading && !checkoutData && (
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
