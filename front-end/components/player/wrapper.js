import React, { Component } from 'react'
import Sound from 'react-sound'

import Player from './index'

class PlayerWrapper extends Component {
  state = {
    isPlaying: false,
    currentTime: 0,
    lastSeekTime: 0,
    totalTime: 0,
    volume: 1
  }

  constructor(props) {
    super(props)

    this.state.totalTime = this.props.track.totalTime
  }

  handleTogglePlay = isPlaying => {
    const { currentTime } = this.state

    this.setState({
      isPlaying,
      lastSeekTime: currentTime
    })
  }

  handleChange = percentage => {
    const { totalTime } = this.state
    const newTime = percentage * totalTime

    this.setState({
      currentTime: newTime
    })
  }

  handleVolumeChange = volume => {
    this.setState({
      volume
    })
  }

  handlePlaying = audio => {
    this.setState({
      currentTime: audio.position
    })
  }

  handleLoad = audio => {
    this.setState({
      totalTime: audio.duration
    })
  }

  handleFinishedPlaying = audio => {
    this.setState({
      isPlaying: false
    })
  }

  render() {
    const { album, track } = this.props
    const {
      isPlaying,
      currentTime,
      totalTime,
      volume,
      lastSeekTime
    } = this.state

    return (
      <div className='djn-playerWrapper'>
        <Player
          currentTime={currentTime}
          totalTime={totalTime}
          track={track}
          album={album}
          isPlaying={isPlaying}
          volume={volume}
          onTogglePlay={this.handleTogglePlay}
          onChange={this.handleChange}
          onVolumeChange={this.handleVolumeChange}
        />

        {track.src && (
          <Sound
            url={track.src}
            volume={volume * 100}
            playStatus={isPlaying ? Sound.status.PLAYING : Sound.status.PAUSED}
            position={currentTime}
            onPlaying={this.handlePlaying}
            onLoad={this.handleLoad}
            onFinishedPlaying={this.handleFinishedPlaying}
          />
        )}
      </div>
    )
  }
}

export default PlayerWrapper
