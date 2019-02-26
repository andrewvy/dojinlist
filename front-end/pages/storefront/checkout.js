import { Link } from '../../routes.js'
import React, { PureComponent } from 'react'
import { Query, Mutation } from 'react-apollo'

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
    checkoutErrors: [],
    checkoutSuccessful: false
  }

  static async getInitialProps({ query }) {
    return { query }
  }

  handleCreateToken = (album, purchaseAlbum, isAuthed) => ({token, email}) => {
    const variables = isAuthed ?
      {
        token: token.id,
        albumId: album.id
      } : {
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
        {({isAuthed}) => (
          <Page>
            <div className='container py-20'>
              <Query query={FetchAlbumBySlugQuery} variables={{slug: album_slug}} >
                {({data, loading}) => (
                  <Mutation mutation={PurchaseAlbumMutation}>
                    {(purchaseAlbum, { data: mutationData, loading, error }) => (
                      <>
                        <Link
                          route='album'
                          params={{storefront_slug, album_slug}}
                        >
                          Back to album
                        </Link>

                        {
                          loading &&
                          <Spinner color='blue' />
                        }

                        {
                          checkoutErrors &&
                          Boolean(checkoutErrors.length) &&
                          <div className='error'>
                            {checkoutErrors.map((error) => (
                              <p>{error.errorMessage}</p>
                            ))}
                          </div>
                        }

                        {
                          checkoutSuccessful &&
                          <div className='success'>
                            <h2>Your purchase was successful!</h2>
                            <p>We sent out a download link to your email, check it out!</p>
                          </div>
                        }

                        {
                          !checkoutSuccessful &&
                          !loading &&
                          !mutationData &&
                          <CheckoutModal onCreateToken={this.handleCreateToken(data.album, purchaseAlbum, isAuthed)} isAuthed={isAuthed}/>
                        }
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
