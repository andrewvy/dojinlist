import FormattedTime from '../../lib/formattedTime.js'

import './index.css'

const AlbumTracklist = ({ album, onTrackClick }) => (
  <div className='djn-albumTracklist'>
    <ol className='tracks'>
      {album.tracks.map((track, i) => (
        <li className='track' key={track.id} onClick={() => onTrackClick(track)}>
          <span className='track-index'>{(i + 1).toString().padStart(2, '0')}</span>
          <span className='track-title'>{track.title}</span>
          <FormattedTime className='track-playlength' numSeconds={track.playLength} />
        </li>
      ))}
    </ol>
  </div>
)

AlbumTracklist.defaultProps = {
  onTrackClick: () => {}
}

export default AlbumTracklist
