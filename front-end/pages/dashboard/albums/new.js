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

const TrackComponent = ({ track, onChange }) => (
  <div className='file'>
    <fieldset>
      <input className='input' type='text' defaultValue={track.title} />
    </fieldset>
  </div>
)

class NewAlbumPage extends React.Component {
  state = {
    generatedId: 0,
    album_name: '',
    album_slug: '',
    album_price: '',
    album_description: '',
    album_cover_art: '',
    preview_album_cover_art: null,
    tracks: []
  }

  onAudioUpload = files => {
    const { generatedId, tracks } = this.state

    let trackGeneratedId = generatedId

    const newTracks = files
      .map(file => {
        let id = trackGeneratedId++

        return {
          id: id,
          title: file.name,
          source_file: file,
          position: 0
        }
      })
      .filter(newTrack => {
        const duplicatedTrack = tracks.find(
          track =>
            track.source_file.name === newTrack.source_file.name &&
            track.source_file.size === newTrack.source_file.size
        )

        return !Boolean(duplicatedTrack)
      })

    this.setState({
      generatedId: trackGeneratedId,
      tracks: [...tracks, ...newTracks]
    })
  }

  onChange = fieldName => e => {
    this.setState({
      [fieldName]: e.target.value
    })
  }

  render() {
    const { tracks } = this.state

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
                                  slug: this.state.album_slug,
                                  storefrontId: me.storefront.id,
                                  coverArt: this.state.album_cover_art,
                                  tracks: this.state.tracks
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
                              imageUrl={this.state.preview_album_cover_art}
                              performUpload={file => {
                                let reader = new FileReader()
                                reader.onload = e => {
                                  this.setState({
                                    preview_album_cover_art: e.target.result
                                  })
                                }

                                reader.readAsDataURL(file)

                                this.setState({ album_cover_art: file })
                              }}
                            />
                          </fieldset>
                          <fieldset>
                            <Label htmlFor='album-name'>Album Name</Label>
                            <input
                              className='input'
                              type='text'
                              placeholder='e.g. Orbital Revolution'
                              id='album-name'
                              value={this.state.album_name}
                              onChange={e => {
                                const album_name = e.target.value
                                const album_slug = slugify(
                                  album_name
                                ).toLowerCase()

                                this.setState({
                                  album_name,
                                  album_slug
                                })
                              }}
                            />
                          </fieldset>
                          <fieldset>
                            <Label htmlFor='album-slug'>Album Slug</Label>
                            <input
                              className='input'
                              type='text'
                              id='album-slug'
                              value={this.state.album_slug}
                              disabled
                            />
                          </fieldset>
                          <fieldset>
                            <Label htmlFor='album-price'>Price ($)</Label>
                            <input
                              className='input'
                              type='text'
                              placeholder='e.g. 9.99'
                              id='album-price'
                              value={this.state.album_price}
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
                              value={this.state.album_description}
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
                                tracks.length ? 'border bg-grey-lightest' : ''
                              }`}
                            >
                              {tracks.map(track => (
                                <TrackComponent track={track} key={track.id} />
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
