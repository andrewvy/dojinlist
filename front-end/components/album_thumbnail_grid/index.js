import AlbumThumbnail from '../album_thumbnail'
import { Link } from '../../routes'

import './index.css'

const AlbumThumbnailGrid = ({ albums, storefront_slug }) => {
  return (
    <div className='djn-albumThumbnailGrid'>
      {
        albums.map((album) => (
          <Link route='album' params={{storefront_slug, album_slug: album.slug}} key={album.id}>
            <a>
              <AlbumThumbnail
                key={album.id}
                album={album}
              />
            </a>
          </Link>
        ))
      }
    </div>
  )
}

export default AlbumThumbnailGrid
