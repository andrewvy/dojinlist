import React from 'react'
import Player from '../components/player/wrapper'

const PlayerContext = React.createContext()

class PlayerProvider extends React.Component {
  state = {
    currentTrack: null,
    isPlaying: false,
    volume: 1,
    showEmbed: false,
  }

  setTrack = (track) => {
    const url = track.sample_url
    const currentUrl = this.state.currentTrack && this.state.currentTrack.sample_url

    if (url === currentUrl) {
      this.setState({
        isPlaying: !this.state.isPlaying
      })
    } else {
      this.setState({
        currentTrack: track,
        isPlaying: true
      })
    }
  }

  setPlaying = (playing) => {
    if (!this.state.currentTrack) return

    this.setState({
      isPlaying: playing
    })
  }

  setVolume = (volume) => {
    this.setState({
      volume
    })
  }

  render() {
    const { currentTrack, isPlaying } = this.state

    const value = {
      setTrack: this.setTrack,
      setPlaying: this.setPlaying,
      setVolume: this.setVolume,
      ...this.state
    }

    return (
      <PlayerContext.Provider
        value={value}
      >
        {this.props.children}
      </PlayerContext.Provider>
    )
  }
}

const PlayerConsumer = PlayerContext.Consumer

export { PlayerProvider, PlayerConsumer }
