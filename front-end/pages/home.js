import withNavigation from '../components/navigation'
import AlbumFeed from '../components/album_feed'
import onlyAuthenticated from '../lib/onlyAuthenticated'
import Page from '../layouts/main.js'

const HomePage = (props) => {
  return (
    <Page>
      <div className='container'>
        <AlbumFeed />
      </div>
    </Page>
  )
}

export default onlyAuthenticated(
  withNavigation(
    HomePage
  )
)
