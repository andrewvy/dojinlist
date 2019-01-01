import React from 'react'
import Dropzone from 'react-dropzone'
import { Mutation } from 'react-apollo'

import Spinner from '../../components/spinner'
import UploadAvatarMutation from '../../mutations/me/upload_avatar.js'
import { MeConsumer } from '../../contexts/me.js'

import './index.css'

class AvatarUploader extends React.Component {
  state = {
    avatar: null,
    isHovered: false,
  }

  constructor(props) {
    super(props)

    this.state.avatar = this.props.avatar
  }

  onDrop = (acceptedFiles) => {
    const { performUploadAvatar } = this.props

    if (acceptedFiles.length) {
      const file = acceptedFiles[0]
      const variables = {
        avatar: file
      }

      this.setState({
        isHovered: false
      })

      performUploadAvatar({variables}).then((response) => {
        this.setState({
          avatar: response.data.uploadAvatar.avatar
        })
      })
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
    const { performUploadAvatar } = this.props
    const { avatar, isHovered } = this.state

    return (
      <div className={`avatar-uploader ${isHovered ? 'is-hovered' : ''}`}>
        <Dropzone
          style={{position: 'relative'}}
          onDragEnter={this.onDragEnter}
          onDragLeave={this.onDragLeave}
          accept="image/jpeg, image/png, image/gif"
          multiple={false}
          onDrop={this.onDrop}
        >
          {
            avatar &&
            <div className='avatar-image'>
              <img src={avatar} width='128' height='128'/>
            </div>
          }

          <div className='avatar-hover'>
            Change avatar
          </div>
        </Dropzone>
      </div>
    )
  }
}

const Wrapper = (props) => (
  <MeConsumer>
    {({ isLoading, me }) => {
      if (isLoading) return (
        <Spinner color='blue-darker' size='large' />
      )

      return (
        <Mutation mutation={UploadAvatarMutation} errorPolicy='all'>
          {(performUploadAvatar) => (
            <AvatarUploader
              avatar={me && me.avatar}
              performUploadAvatar={performUploadAvatar}
              {...props}
            />
          )}
        </Mutation>
      )
    }}
  </MeConsumer>
)

export default Wrapper
