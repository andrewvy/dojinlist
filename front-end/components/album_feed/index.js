import { Query } from 'react-apollo'

import FetchAlbumsQuery from '../../queries/albums.js'

const AlbumFeed = () => {
  return (
    <Query query={FetchAlbumsQuery}>
    {({loading, data}) => (
      <div>
        {loading && <div>Loading</div>}
        {
          data && (
            <div>
              {
                data.albums.edges.map((album) => (
                  <div className='album'>
                    <div>{album.node.name}</div>
                    <div><b>Event:</b> {album.node.event.name}</div>
                    <div><b>Genres:</b> {album.node.genres.map((genre) => genre.name).join(' ')}</div>
                    <div><b>Track Count:</b> {album.node.tracks.length}</div>
                    <img src={album.node.coverArtUrl} />
                  </div>
                ))
              }
            </div>
          )
        }
        <style jsx='true'>{`
        .album + .album {
          margin-top: 8px;
        }
        `}</style>
      </div>
    )}
    </Query>
  )
}

export default AlbumFeed
