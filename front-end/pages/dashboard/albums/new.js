import { Mutation } from 'react-apollo'

import { MeConsumer } from '../../../contexts/me'

import withOnlyAuthenticated from '../../../lib/onlyAuthenticated'

import withNavigation from '../../../components/navigation'
import Button from '../../../components/button'
import Spinner from '../../../components/spinner'
import AlbumCreator from '../../../components/album_creator'

import CreateAlbumMutation from '../../../mutations/albums/create_album'

import Page from '../../../layouts/main'

import './new.css'

class NewAlbumPage extends React.Component {
  state = {
    isCreating: false,
    progressPercentage: 0.0,
    album: {
      tracks: []
    },
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
    const { tracks, isCreating, progressPercentage } = this.state

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
                                  tracks: album.tracks.map(
                                    (track, index) => ({
                                      title: track.title,
                                      sourceFile: track.sourceFile,
                                      position: index + 1
                                    })
                                  )
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
                              }).finally(() => {
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

export default withOnlyAuthenticated(withNavigation(NewAlbumPage))
