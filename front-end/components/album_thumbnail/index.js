import Link from 'next/link'
import React from 'react'

import './index.css'

const AlbumThumbnail = ({ album, subdomain }) => {
  return (
    <Link
      href={`/storefront/albums?subdomain=${subdomain}&album_slug=${album.slug}`}
      as={`/albums/${album.slug}`}
    >
      <div className='djn-albumThumbnail'>
        <img className='thumbnail' src={album.coverArtUrl} />
        <div className='album-meta'>
          <div className='album-name'>{album.title}</div>
          <div className='album-artist'>{album.artistName}</div>
        </div>
      </div>
    </Link>
  )
}

export default AlbumThumbnail
