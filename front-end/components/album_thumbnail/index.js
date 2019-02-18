import React from 'react'

import './index.css'

const AlbumThumbnail = ({ album }) => {
  return (
    <div className='djn-albumThumbnail'>
      <img className='thumbnail' src={album.coverArtUrl} />
      <div className='album-meta'>
        <div className='album-name'>{album.title}</div>
        <div className='album-artist'>{album.artistName}</div>
      </div>
    </div>
  )
}

export default AlbumThumbnail
