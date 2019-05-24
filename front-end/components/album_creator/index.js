import React, { useState } from 'react'
import Textarea from 'react-autosize-textarea'

import arrayMove from '../../lib/array_move'
import { withNamespaces } from '../../lib/i18n'

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
  onTrackDelete,
  onAudioUpload,
  t
}) => {
  const [previewCoverArt, setPreviewCoverArt] = useState(album.coverArtUrl)

  return (
    <form>
      <fieldset>
        <Label htmlFor='album-cover'>{t('album-cover')}</Label>
        <Description>{t('album-cover-description')}</Description>
        <Uploader
          placeholder={t('album-cover-placeholder')}
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
        <Label htmlFor='album-title'>{t('album-title')}</Label>
        <input
          className='input'
          type='text'
          placeholder={t('album-title-placeholder')}
          id='album-title'
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
        <Label htmlFor='album-slug'>{t('album-slug')}</Label>
        <input
          className='input'
          type='text'
          id='album-slug'
          value={album.slug}
          disabled
        />
      </fieldset>
      <fieldset>
        <Label htmlFor='album-currency'>{t('album-currency')}</Label>
        <select>
          <option>USD</option>
        </select>
      </fieldset>
      <fieldset>
        <Label htmlFor='album-price'>{t('album-price')}</Label>
        <input
          className='input'
          type='text'
          placeholder={t('album-price-placeholder')}
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
        <Label htmlFor='album-description'>{t('album-description')}</Label>
        <Textarea
          placeholder={t('album-description-placeholder')}
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
        <Label>{t('album-track-uploader')}</Label>
        <div className='track-uploader'>
          <Description>{t('album-track-uploader-description')}</Description>
          <Uploader
            multiple={true}
            placeholder={t('album-track-uploader-placeholder')}
            accept='audio/flac, audio/aiff, audio/wav'
            type='rectangle'
            performUpload={onAudioUpload}
          />
        </div>
      </fieldset>
      <div className='tracks'>
        <Label>{t('album-tracks')}</Label>
        <Description>
          {t('album-tracks-description')}
        </Description>

        <TrackListComponent
          tracks={album.tracks}
          onChange={onTrackChange}
          onSort={onTrackSort}
          onDelete={onTrackDelete}
        />
      </div>
    </form>
  )
}

class AlbumCreatorContainer extends React.Component {
  state = {
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

  onTrackDelete = (indexToRemove) => {
    const { album, onAlbumChange } = this.props
    const newTracks = album.tracks.filter((track, index) => index !== indexToRemove)

    onAlbumChange({
      tracks: newTracks
    })
  }

  render() {
    const { album, onAlbumChange, t } = this.props

    return (
      <AlbumCreator
        album={album}
        onAlbumChange={onAlbumChange}
        onTrackChange={this.onTrackChange}
        onTrackSort={this.onTrackSort}
        onAudioUpload={this.onAudioUpload}
        onTrackDelete={this.onTrackDelete}
        t={t}
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

export default withNamespaces('dashboard')(AlbumCreatorContainer)
