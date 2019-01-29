import React, { Component } from 'react'

import Player from '../../components/player'
import ProgressBar from '../../components/player/progressBar.js'

import Page from '../../layouts/main.js'

import { HeaderStyles, SubheaderStyles } from '../../lib/styleguideUtils.js'

const track = {
  name: 'T'
}

const album = {
  artist_name: 'Tycho',
  name: 'ボーナス・トラック'
}

class PlayerWrapper extends Component {
  state = {
    isPlaying: false,
    currentTime: 30,
    totalTime: 120,
    volume: 1,
  }

  handleTogglePlay = (isPlaying) => {
    this.setState({
      isPlaying
    })
  }

  handleChange = (percentage) => {
    const { totalTime } = this.state
    const newTime = percentage * totalTime

    this.setState({
      currentTime: newTime
    })
  }

  handleVolumeChange = (volume) => {
    this.setState({
      volume
    })
  }

  render() {
    const { isPlaying, currentTime, totalTime, volume } = this.state

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
          />
        </div>
      </div>
    </Page>
  )
}

export default PlayerPage
