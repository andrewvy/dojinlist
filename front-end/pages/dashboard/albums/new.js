import Textarea from 'react-autosize-textarea'
import { Mutation } from 'react-apollo'
import slugify from 'slugify'
import {
  sortableContainer,
  sortableElement,
  sortableHandle
} from 'react-sortable-hoc'

import { MeConsumer } from '../../../contexts/me'
import withOnlyAuthenticated from '../../../lib/onlyAuthenticated'
import arrayMove from '../../../lib/array_move'

import withNavigation from '../../../components/navigation'
import Label from '../../../components/label'
import Description from '../../../components/description'
import Button from '../../../components/button'
import Uploader from '../../../components/uploader'
import Spinner from '../../../components/spinner'

import CreateAlbumMutation from '../../../mutations/albums/create_album'

import Page from '../../../layouts/main'

import './new.css'

const DragHandle = sortableHandle(() => <div>::</div>)

const SortableItem = sortableElement(({ value, index }) => (
  <li>
    <div className='file'>
      <DragHandle />
      <span>{index + 1}</span>
      <fieldset>
        <input className='input' type='text' defaultValue={value.title} />
      </fieldset>
    </div>
  </li>
))

const SortableContainer = sortableContainer(({ children }) => (
  <ul>{children}</ul>
))

const TrackComponent = ({ track, onChange }) => (
  <div className='file'>
    <fieldset>
      <input className='input' type='text' defaultValue={track.title} />
    </fieldset>
  </div>
)

class NewAlbumPage extends React.Component {
  state = {
    isCreating: false,
    progressPercentage: 0.00,
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
          source_file: file
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

  onTrackSort = ({ oldIndex, newIndex }) => {
    const { tracks } = this.state

    this.setState({
      tracks: arrayMove(tracks, oldIndex, newIndex)
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
                          <Button type='primary' text='Publish Album' disabled/>
                          <Button
                            type='translucent'
                            text='Save draft'
                            disabled={isCreating}
                            onClick={() => {
                              let variables = {
                                album: {
                                  title: this.state.album_name,
                                  slug: this.state.album_slug,
                                  storefrontId: me.storefront.id,
                                  tracks: this.state.tracks.map(
                                    (track, index) => ({
                                      title: track.title,
                                      source_file: track.source_file,
                                      position: index + 1
                                    })
                                  )
                                }
                              }

                              if (this.state.album_cover_art) {
                                variables.album.coverArt = this.state.album_cover_art
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
                              <SortableContainer
                                onSortEnd={this.onTrackSort}
                                useDragHandle
                              >
                                {tracks.map((track, index) => (
                                  <SortableItem
                                    key={track.id}
                                    index={index}
                                    value={track}
                                  />
                                ))}
                              </SortableContainer>
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
