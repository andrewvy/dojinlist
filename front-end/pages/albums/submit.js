import React from 'react'
import AlbumCreator from '../../components/album_creator'

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

export default SubmitPage
