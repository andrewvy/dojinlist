import { Mutation } from 'react-apollo'

import { MeConsumer } from '../../../contexts/me'

import withOnlyAuthenticated from '../../../lib/onlyAuthenticated'

import Button from '../../../components/button'
import Spinner from '../../../components/spinner'
import AlbumCreator from '../../../components/album_creator'
import Error from '../../../components/error'

import CreateAlbumMutation from '../../../mutations/albums/create_album'

import Page from '../../../layouts/main'

import './new.css'

const newAlbum = {
  currency: 'USD',
  tracks: []
}

class NewAlbumPage extends React.Component {
  state = {
    isCreating: false,
    errors: null,
    successful: false,
    progressPercentage: 0.0,
    album: newAlbum
  }

  onChange = fieldName => e => {
    this.setState({
      [fieldName]: e.target.value
    })
  }

  onAlbumChange = changes => {
    const { album } = this.state

    this.setState({
      album: {
        ...album,
        ...changes
      }
    })
  }

  render() {
    const {
      tracks,
      isCreating,
      progressPercentage,
      errors,
      successful
    } = this.state

    return (
      <MeConsumer>
        {({ isLoading, me }) => {
          if (isLoading) {
            return (
              <div className='container vertical-center'>
                <Spinner color='blue-darker' size='large' />
              </div>
            )
          } else {
            return (
              <Mutation mutation={CreateAlbumMutation} errorPolicy='all'>
                {performCreateAlbum => (
                  <Page className='djn-newAlbumPage'>
                    <div className='container'>
                      <div className='header'>
                        <div className='actions'>
                          <Button
                            type='translucent'
                            text='Save draft'
                            disabled={isCreating}
                            onClick={() => {
                              const { album } = this.state

                              let variables = {
                                album: {
                                  title: album.title,
                                  slug: album.slug,
                                  storefrontId: me.storefront.id,
                                  price: `${album.currency} ${album.price}`,
                                  tracks: album.tracks.map((track, index) => ({
                                    title: track.title,
                                    sourceFile: track.sourceFile,
                                    position: index + 1
                                  }))
                                }
                              }

                              if (album.coverArt) {
                                variables.album.coverArt = album.coverArt
                              }

                              this.setState({
                                isCreating: true
                              })

                              performCreateAlbum({
                                variables,
                                context: {
                                  fetchOptions: {
                                    onUploadProgress: progress => {
                                      const progressPercentage =
                                        progress.loaded / progress.total

                                      this.setState({
                                        progressPercentage
                                      })
                                    }
                                  }
                                }
                              })
                                .then(resp => {
                                  const {
                                    album,
                                    errors
                                  } = resp.data.createAlbum

                                  const successful =
                                    errors === null || errors.length === 0

                                  let newState = {
                                    errors,
                                    successful
                                  }

                                  if (successful) {
                                    newState.album = newAlbum
                                  }

                                  this.setState(newState)
                                })
                                .finally(() => {
                                  this.setState({
                                    isCreating: false
                                  })
                                })
                            }}
                          />
                          {isCreating && (
                            <div className='text-grey-dark py-2'>
                              Uploading{' '}
                              {progressPercentage.toLocaleString(undefined, {
                                style: 'percent',
                                minimumFractionDigits: 2
                              })}
                            </div>
                          )}
                          {successful && (
                            <div className='container success xl:w-1/3 md:1/2 xs:w-5/6 flex content-center items-center flex-col bg-green-light rounded text-white font-bold'>
                              <p>Created album</p>
                            </div>
                          )}
                          {errors &&
                            errors.map(error => (
                              <Error>{error.errorMessage}</Error>
                            ))}
                        </div>
                      </div>
                      <div className='content shadow rounded'>
                        <AlbumCreator
                          album={this.state.album}
                          onAlbumChange={this.onAlbumChange}
                        />
                      </div>
                    </div>
                  </Page>
                )}
              </Mutation>
            )
          }
        }}
      </MeConsumer>
    )
  }
}

export default withOnlyAuthenticated(NewAlbumPage)
