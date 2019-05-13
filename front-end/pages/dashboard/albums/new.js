import Textarea from 'react-autosize-textarea'

import withOnlyAuthenticated from '../../../lib/onlyAuthenticated'
import withNavigation from '../../../components/navigation'
import Label from '../../../components/label'
import Description from '../../../components/description'
import Button from '../../../components/button'

import Uploader from '../../../components/uploader'

import Page from '../../../layouts/main'

import './new.css'

class NewAlbumPage extends React.Component {
  state = {
    audioFiles: []
  }

  onAudioUpload = files => {
    const { audioFiles } = this.state

    this.setState({
      audioFiles: [...audioFiles, ...files]
    })
  }

  render() {
    const { audioFiles } = this.state

    return (
      <Page className='djn-newAlbumPage'>
        <div className='container'>
          <div className='header'>
            <div className='actions'>
              <Button type='primary' text='Publish Album' disabled />
              <Button type='translucent' text='Save draft' />
            </div>
          </div>
          <div className='content shadow rounded'>
            <form>
              <fieldset>
                <Label htmlFor='album-name'>Artwork</Label>
                <Description>Upload your cover art.</Description>
                <Uploader placeholder='Add artwork' />
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
                  rows={5}
                  maxRows={15}
                />
              </fieldset>
              <fieldset>
                <Label>Upload your music files</Label>
                <div className='track-uploader'>
                  <Description>
                    Choose your files or drag them here.
                  </Description>
                  <Uploader
                    multiple={true}
                    placeholder='Add files'
                    accept='audio/flac, audio/aiff, audio/wav'
                    type='rectangle'
                    performUpload={this.onAudioUpload}
                  />
                </div>
              </fieldset>
              <div className='tracks'>
                <Label>Your Tracks</Label>
                <Description>
                  You can re-arrange the order of the music and edit the track
                  names.
                </Description>

                <div className={`files rounded ${audioFiles.length ? 'border bg-grey-lightest' : ''}`}>
                  {
                    audioFiles.map((file) => (
                      <div className='file'>
                        <span className='name' key={file.name}>{file.name}</span>
                      </div>
                    ))
                  }
                </div>
              </div>
            </form>
          </div>
        </div>
      </Page>
    )
  }
}

export default withOnlyAuthenticated(withNavigation(NewAlbumPage))
