import Textarea from 'react-autosize-textarea'
import { Mutation } from 'react-apollo'
import slugify from 'slugify'

import { MeConsumer } from '../../../contexts/me'
import withOnlyAuthenticated from '../../../lib/onlyAuthenticated'

import withNavigation from '../../../components/navigation'
import Label from '../../../components/label'
import Description from '../../../components/description'
import Button from '../../../components/button'
import Uploader from '../../../components/uploader'
import Spinner from '../../../components/spinner'

import CreateAlbumMutation from '../../../mutations/albums/create_album'

import Page from '../../../layouts/main'

import './new.css'

class NewAlbumPage extends React.Component {
  state = {
    album_name: '',
    album_price: '',
    album_description: '',
    album_cover_art: '',
    audioFiles: []
  }

  onAudioUpload = files => {
    const { audioFiles } = this.state

    this.setState({
      audioFiles: [...audioFiles, ...files]
    })
  }

  onChange = fieldName => e => {
    this.setState({
      [fieldName]: e.target.value
    })
  }

  render() {
    const { audioFiles } = this.state

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
                          <Button type='primary' text='Publish Album' />
                          <Button
                            type='translucent'
                            text='Save draft'
                            onClick={() => {
                              const variables = {
                                album: {
                                  title: this.state.album_name,
                                  slug: slugify(this.state.album_name),
                                  storefrontId: me.storefront.id,
                                  coverArt: this.state.album_cover_art,
                                  tracks: this.state.audioFiles.map(file => ({
                                    title: file.name,
                                    source_file: file
                                  }))
                                }
                              }

                              performCreateAlbum({ variables })
                            }}
                          />
                        </div>
                      </div>
                      <div className='content shadow rounded'>
                        <form>
                          <fieldset>
                            <Label htmlFor='album-name'>Artwork</Label>
                            <Description>Upload your cover art.</Description>
                            <Uploader
                              placeholder='Add artwork'
                              performUpload={file =>
                                this.setState({ album_cover_art: file })
                              }
                            />
                          </fieldset>
                          <fieldset>
                            <Label htmlFor='album-name'>Album Name</Label>
                            <input
                              className='input'
                              type='text'
                              placeholder='e.g. Orbital Revolution'
                              id='album-name'
                              onChange={this.onChange('album_name')}
                            />
                          </fieldset>
                          <fieldset>
                            <Label htmlFor='album-price'>Price ($)</Label>
                            <input
                              className='input'
                              type='text'
                              placeholder='e.g. 9.99'
                              id='album-price'
                              onChange={this.onChange('album_price')}
                            />
                          </fieldset>
                          <fieldset>
                            <Label htmlFor='album-description'>
                              Description
                            </Label>
                            <Textarea
                              placeholder='Write about your album'
                              id='album-description'
                              rows={5}
                              maxRows={15}
                              onChange={this.onChange('album_description')}
                            />
                          </fieldset>
                          <fieldset>
                            <Label>Upload your music files</Label>
                            <div className='track-uploader'>
                              <Description>
                                Choose your files or drag them here.
                              </Description>
                              <Uploader
                                multiple={true}
                                placeholder='Add files'
                                accept='audio/flac, audio/aiff, audio/wav'
                                type='rectangle'
                                performUpload={this.onAudioUpload}
                              />
                            </div>
                          </fieldset>
                          <div className='tracks'>
                            <Label>Your Tracks</Label>
                            <Description>
                              You can re-arrange the order of the music and edit
                              the track names.
                            </Description>

                            <div
                              className={`files rounded ${
                                audioFiles.length
                                  ? 'border bg-grey-lightest'
                                  : ''
                              }`}
                            >
                              {audioFiles.map(file => (
                                <div className='file'>
                                  <span className='name' key={file.name}>
                                    {file.name}
                                  </span>
                                </div>
                              ))}
                            </div>
                          </div>
                        </form>
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
