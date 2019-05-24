import React, { useState } from 'react'
import Textarea from 'react-autosize-textarea'
import arrayMove from '../../lib/array_move'

import slugify from 'slugify'
import Label from '../label'
import Description from '../description'
import Uploader from '../uploader'

import TrackListComponent from './track_list'
import { TrackSchema, AlbumSchema } from './schemas'

import './index.css'

const AlbumCreator = ({
  album,
  onAlbumChange,
  onTrackChange,
  onTrackSort,
  onAudioUpload
}) => {
  const [previewCoverArt, setPreviewCoverArt] = useState(album.coverArtUrl)

  return (
    <form>
      <fieldset>
        <Label htmlFor='album-name'>Artwork</Label>
        <Description>Upload your cover art.</Description>
        <Uploader
          placeholder='Add artwork'
          imageUrl={previewCoverArt}
          performUpload={file => {
            let reader = new FileReader()

            reader.onload = e => {
              setPreviewCoverArt(e.target.result)
            }

            reader.readAsDataURL(file)

            onAlbumChange({
              coverArt: file
            })
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
          value={album.title}
          onChange={e => {
            const title = e.target.value
            const slug = slugify(title).toLowerCase()

            onAlbumChange({
              title,
              slug
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
          value={album.slug}
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
          value={album.price}
          onChange={e => {
            const value = e.target.value

            onAlbumChange({
              price: value
            })
          }}
        />
      </fieldset>
      <fieldset>
        <Label htmlFor='album-description'>Description</Label>
        <Textarea
          placeholder='Write about your album'
          id='album-description'
          rows={5}
          maxRows={15}
          value={album.description}
          onChange={e => {
            const value = e.target.value

            onAlbumChange({
              description: value
            })
          }}
        />
      </fieldset>
      <fieldset>
        <Label>Upload your music files</Label>
        <div className='track-uploader'>
          <Description>Choose your files or drag them here.</Description>
          <Uploader
            multiple={true}
            placeholder='Add files'
            accept='audio/flac, audio/aiff, audio/wav'
            type='rectangle'
            performUpload={onAudioUpload}
          />
        </div>
      </fieldset>
      <div className='tracks'>
        <Label>Your Tracks</Label>
        <Description>
          You can re-arrange the order of the music and edit the track names.
        </Description>

        <TrackListComponent
          tracks={album.tracks}
          onChange={onTrackChange}
          onSort={onTrackSort}
        />
      </div>
    </form>
  )
}

class AlbumCreatorContainer extends React.Component {
  state = {
    album: {
      tracks: []
    },
    generatedId: 0
  }

  onAudioUpload = files => {
    const { album, onAlbumChange } = this.props
    const { generatedId } = this.state

    let trackGeneratedId = generatedId

    const newTracks = files
      .map(file => {
        let id = trackGeneratedId++

        return {
          id: id,
          title: file.name,
          sourceFile: file
        }
      })
      .filter(newTrack => {
        const duplicatedTrack = album.tracks.find(
          track =>
            track.sourceFile.name === newTrack.sourceFile.name &&
            track.sourceFile.size === newTrack.sourceFile.size
        )

        return !Boolean(duplicatedTrack)
      })

    this.setState({
      generatedId: trackGeneratedId
    })

    onAlbumChange({
      tracks: [...album.tracks, ...newTracks]
    })
  }

  onTrackChange = (indexToUpdate, newTrack) => {
    const { album, onAlbumChange } = this.props

    const newTracks = album.tracks.map((track, index) => {
      if (index === indexToUpdate) {
        return {
          ...track,
          ...newTrack
        }
      } else {
        return track
      }
    })

    onAlbumChange({
      tracks: newTracks
    })
  }

  onTrackSort = ({ oldIndex, newIndex }) => {
    const { album, onAlbumChange } = this.props

    onAlbumChange({
        tracks: arrayMove(album.tracks, oldIndex, newIndex)
    })
  }

  render() {
    const { album, onAlbumChange } = this.props

    return (
      <AlbumCreator
        album={album}
        onAlbumChange={onAlbumChange}
        onTrackChange={this.onTrackChange}
        onTrackSort={this.onTrackSort}
        onAudioUpload={this.onAudioUpload}
      />
    )
  }
}

AlbumCreatorContainer.defaultProps = {
  onAlbumChange: () => {},
  onSubmit: () => {},
  album: {
    tracks: [],
  }
}

export default AlbumCreatorContainer
