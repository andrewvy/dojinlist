import React, { Component } from 'react'

import Sound from 'react-sound'

import Player from '../../components/player'
import ProgressBar from '../../components/player/progressBar.js'

import Page from '../../layouts/main.js'

import { HeaderStyles, SubheaderStyles } from '../../lib/styleguideUtils.js'

const track = {
  name: 'T',
  src: 'https://assets.dojinlist.co/uploads/a2002011001-e02-128k.ogg',
  totalTime: 54 * 1000,
}

const album = {
  artist_name: 'Tycho',
  name: 'ボーナス・トラック'
}

class PlayerWrapper extends Component {
  state = {
    isPlaying: false,
    currentTime: 0,
    lastSeekTime: 0,
    totalTime: 0,
    volume: 1,
  }

  constructor(props) {
    super(props)

    this.state.totalTime = this.props.track.totalTime
  }

  handleTogglePlay = (isPlaying) => {
    const { currentTime } = this.state

    this.setState({
      isPlaying,
      lastSeekTime: currentTime
    })
  }

  handleChange = (percentage) => {
    const { totalTime } = this.state
    const newTime = percentage * totalTime

    this.setState({
      currentTime: newTime,
    })
  }

  handleVolumeChange = (volume) => {
    this.setState({
      volume
    })
  }

  handlePlaying = (audio) => {
    this.setState({
      currentTime: audio.position
    })
  }

  handleLoad = (audio) => {
    this.setState({
      totalTime: audio.duration
    })
  }

  handleFinishedPlaying = (audio) => {
    this.setState({
      isPlaying: false
    })
  }

  render() {
    const { album, track } = this.props
    const { isPlaying, currentTime, totalTime, volume, lastSeekTime } = this.state

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
        <Sound
          url={track.src}
          volume={volume * 100}
          playStatus={isPlaying ? Sound.status.PLAYING : Sound.status.PAUSED}
          position={currentTime}
          onPlaying={this.handlePlaying}
          onLoad={this.handleLoad}
          onFinishedPlaying={this.handleFinishedPlaying}
        />
      </div>
    )
  }
}

const PlayerPage = (props) => {
  return (
    <Page>
      <div className='container limit-screen p-8'>
        <h1 className={HeaderStyles}>Player</h1>
        <div className='my-8'>
          <div className={SubheaderStyles}>ProgressBar</div>
          <ProgressBar
            isEnabled
            direction='HORIZONTAL'
            value={0.5}
            onChange={() => {}}
            onIntent={(intent) => console.log(intent)}
          />
        </div>
        <div className='my-8'>
          <div className={SubheaderStyles}>Player</div>
          <PlayerWrapper
            track={track}
            album={album}
          />
        </div>
      </div>
    </Page>
  )
}

export default PlayerPage
