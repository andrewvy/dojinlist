import React from 'react'

const PlayerContext = React.createContext()

class PlayerProvider extends React.Component {
  state = {
    currentTrack: null,
    currentUrl: null,
    isPlaying: false,
    volume: 1,
    showEmbed: false,
  }

  setTrack = (track) => {
    const url = track.sample_url

    if (url === this.state.currentUrl) {
      this.setState({
        isPlaying: !this.state.isPlaying
      })
    } else {
      this.setState({
        currentTrack: track,
        currentUrl: url,
        isPlaying: true
      })
    }
  }

  setPlaying = (playing) => {
    if (!this.state.currentUrl) return

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
