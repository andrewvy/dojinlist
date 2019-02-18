import Link from 'next/link'
import AlbumThumbnail from '../album_thumbnail'

import './index.css'

const AlbumThumbnailGrid = ({ albums }) => {
  return (
    <div className='djn-albumThumbnailGrid'>
      {
        albums.map((album) => (
          <AlbumThumbnail
            key={album.id}
            album={album}
          />
        ))
      }
    </div>
  )
}

export default AlbumThumbnailGrid
