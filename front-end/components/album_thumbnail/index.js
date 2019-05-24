import React from 'react'
import classNames from 'classnames'

import './index.css'

const AlbumThumbnail = ({ album }) => {
  return (
    <div className='djn-albumThumbnail'>
      <img
        className={classNames('thumbnail', { empty: !Boolean(album.coverArtUrl) })}
        src={album.coverArtUrl}
        width={180}
        height={180}
      />
      <div className='album-meta'>
        <div className='album-name'>{album.title}</div>
        <div className='album-artist'>{album.artistName}</div>
      </div>
    </div>
  )
}

export default AlbumThumbnail
