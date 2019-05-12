import React from 'react'
import Dropzone from 'react-dropzone'

import Spinner from '../../components/spinner'
import { MeConsumer } from '../../contexts/me.js'

import IconPlus from '../../svgs/icons/icon-plus.svg'

import './index.css'

class Uploader extends React.Component {
  static defaultProps = {
    performUpload: () => {}
  }

  state = {
    isHovered: false
  }

  onDrop = acceptedFiles => {
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
    const { imageUrl, placeholder, multiple, accept, type } = this.props
    const { isHovered } = this.state

    return (
      <div className={`djn-uploader ${isHovered ? 'is-hovered' : ''} ${type}`}>
        <Dropzone
          style={{ position: 'relative' }}
          onDragEnter={this.onDragEnter}
          onDragLeave={this.onDragLeave}
          accept={accept}
          multiple={multiple}
          onDrop={this.onDrop}
          className='uploader'
        >
          {imageUrl && (
            <div className='uploader-image'>
              <img src={imageUrl} width='128' height='128' />
            </div>
          )}

          {!imageUrl && (
            <div className='placeholder'>
              <div className='text'>{placeholder}</div>
              <IconPlus fill='inherit' className='icon' />
            </div>
          )}

          <div className='uploader-hover'>Upload</div>
        </Dropzone>
      </div>
    )
  }
}

Uploader.defaultProps = {
  type: 'default',
  placeholder: 'Upload',
  multiple: false,
  accept: 'image/jpeg, image/png, image/gif'
}

export default Uploader
