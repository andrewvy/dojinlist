import Textarea from 'react-autosize-textarea'

import withOnlyAuthenticated from '../../../lib/onlyAuthenticated'
import withNavigation from '../../../components/navigation'
import Label from '../../../components/label'
import Description from '../../../components/description'

import Page from '../../../layouts/main'

import './new.css'

const NewAlbumPage = () => (
  <Page className='djn-newAlbumPage'>
    <div className='container rounded'>
      <form>
        <fieldset>
          <Label htmlFor='album-name'>Artwork</Label>
          <Description>Upload your cover art.</Description>
        </fieldset>
        <fieldset>
          <Label htmlFor='album-name'>Album Name</Label>
          <input
            className='input'
            type='text'
            placeholder='e.g. Orbital Revolution'
            id='album-name'
          />
        </fieldset>
        <fieldset>
          <Label htmlFor='album-price'>Price ($)</Label>
          <input
            className='input'
            type='text'
            placeholder='e.g. 9.99'
            id='album-price'
          />
        </fieldset>
        <fieldset>
          <Label htmlFor='album-description'>Description</Label>
          <Textarea
            placeholder='Write about your album'
            id='album-description'
            maxRows={15}
          />
        </fieldset>
        <fieldset>
          <Label>Upload your music files</Label>
          <div className='track-uploader'>
            <Description>Choose your files or drag them here.</Description>
          </div>
        </fieldset>
        <div className='tracks'>
          <Label>Your Tracks</Label>
          <Description>
            You can re-arrange the order of the music and edit the track names.
          </Description>
        </div>
      </form>
    </div>
  </Page>
)

export default withOnlyAuthenticated(withNavigation(NewAlbumPage))
