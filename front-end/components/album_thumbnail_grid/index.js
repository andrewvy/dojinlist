import Link from 'next/link'
import AlbumThumbnail from '../album_thumbnail'

import './index.css'

const AlbumThumbnailGrid = ({ albums, subdomain }) => {
  return (
    <div className='djn-albumThumbnailGrid'>
      {
        albums.map((album) => (
          <AlbumThumbnail
            key={album.id}
            album={album}
            subdomain={subdomain}
          />
        ))
      }
    </div>
  )
}

export default AlbumThumbnailGrid
