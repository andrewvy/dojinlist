import React from 'react'
import AlbumCreator from '../../components/album_creator'
import withNavigation from '../../components/navigation'

import Page from '../../layouts/main.js'

class SubmitPage extends React.Component {
  render() {
    return (
      <Page>
        <AlbumCreator />
      </Page>
    )
  }
}

export default withNavigation(SubmitPage)
