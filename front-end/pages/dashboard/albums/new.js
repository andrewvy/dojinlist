import withOnlyAuthenticated from '../../../lib/onlyAuthenticated'
import withNavigation from '../../../components/navigation'

import Page from '../../../layouts/main'

const NewAlbumPage = () => (
  <Page>
    <div>New album</div>
  </Page>
)

export default withOnlyAuthenticated(withNavigation(NewAlbumPage))
