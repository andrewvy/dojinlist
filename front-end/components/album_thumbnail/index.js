import React from 'react'

import './index.css'

const AlbumThumbnail = ({ album }) => {
  return (
    <div className='djn-albumThumbnail'>
      <img className='thumbnail' src={album.cover_image_url} />
      <div className='album-meta'>
        <div className='album-name'>{album.name}</div>
        <div className='album-artist'>{album.artist_name}</div>
      </div>
    </div>
  )
}

export default AlbumThumbnail
