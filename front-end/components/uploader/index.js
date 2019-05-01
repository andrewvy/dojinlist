import React from 'react'
import Dropzone from 'react-dropzone'

import Spinner from '../../components/spinner'
import { MeConsumer } from '../../contexts/me.js'

import './index.css'

class Uploader extends React.Component {
  static defaultProps = {
    performUpload: () => {}
  }

  state = {
    isHovered: false,
  }

  onDrop = (acceptedFiles) => {
    const { performUpload } = this.props

    if (acceptedFiles.length) {
      const file = acceptedFiles[0]

      this.setState({
        isHovered: false
      })

      performUpload(file)
    }
  }

  onDragEnter = () => {
    this.setState({
      isHovered: true
    })
  }

  onDragLeave = () => {
    this.setState({
      isHovered: false
    })
  }

  render() {
    const { imageUrl } = this.props
    const { isHovered } = this.state

    return (
      <div className={`djn-uploader ${isHovered ? 'is-hovered' : ''}`}>
        <Dropzone
          style={{position: 'relative'}}
          onDragEnter={this.onDragEnter}
          onDragLeave={this.onDragLeave}
          accept="image/jpeg, image/png, image/gif"
          multiple={false}
          onDrop={this.onDrop}
        >
          {
            imageUrl &&
            <div className='uploader-image'>
              <img src={imageUrl} width='128' height='128'/>
            </div>
          }

          <div className='uploader-hover'>
            Upload
          </div>
        </Dropzone>
      </div>
    )
  }
}

export default Uploader
