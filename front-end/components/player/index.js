import React, { Component } from 'react'

import Button from '../button'

import ProgressBar from './progressBar.js'
import FormattedTime from '../../lib/formattedTime.js'

import IconPlay from '../../svgs/icons/icon-play.svg'
import IconPause from '../../svgs/icons/icon-pause.svg'
import IconVolume from '../../svgs/icons/icon-volume.svg'

import './index.css'

class Player extends Component {
  static defaultProps = {
    track: null,
    album: {},
    isPlaying: false,
    currentTime: 0,
    totalTime: 120,
    volume: 1,
  }

  handleTogglePlay() {
    const { isPlaying } = this.props
    if (this.props.onTogglePlay) {
      this.props.onTogglePlay(!isPlaying)
    }
  }

  handleChange = (percentage) => {
    if (this.props.onChange) {
      this.props.onChange(percentage)
    }
  }

  handleVolumeChange = (percentage) => {
    if (this.props.onVolumeChange) {
      this.props.onVolumeChange(percentage)
    }
  }

  render() {
    const { isPlaying, currentTime, totalTime, track, album, volume } = this.props

    return (
      <div className={`djn-player ${(isPlaying || track) ? 'is-playing' : ''}`}>
        <ProgressBar
          isEnabled
          direction='HORIZONTAL'
          value={currentTime / totalTime}
          onChange={this.handleChange}
        />
        <div className='inner'>
          <div className='play-button'>
            {
              !isPlaying &&
              <IconPlay className='icon' width='48px' height='48px' fill='inherit' onClick={this.handleTogglePlay.bind(this)}/>
            }
            {
              isPlaying &&
              <IconPause className='icon' width='48px' height='48px' fill='inherit' onClick={this.handleTogglePlay.bind(this)}/>
            }
          </div>
          <div className='album-art'>
          </div>
          <div className='album-meta'>
            {track ? (
              <>
              <div className='track-name'>{track.title}</div>
              <div className='album'>
                <span className='artist-name'>{album.artist_name} - </span>
                <span className='album-name'>{album.name}</span>
              </div>
              </>
            ) : (
              <div className='track-name'>Not playing anything</div>
            )}
          </div>
          <div className='djn-volumeSlider'>
            <IconVolume className='icon'/>
            <ProgressBar
              isEnabled
              direction='HORIZONTAL'
              value={volume}
              onChange={this.handleVolumeChange}
            />
          </div>
          <div className='timestamp font-mono'>
            <FormattedTime numSeconds={currentTime / 1000} className='font-mono'/> / <FormattedTime numSeconds={totalTime / 1000} className='font-mono text-grey'/>
          </div>
          <Button type='translucent-dark' text='Buy Album'/>
        </div>
      </div>
    )
  }
}

export default Player
