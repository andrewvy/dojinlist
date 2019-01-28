import React, { Component } from 'react'

import Button from '../button'

import ProgressBar from './progressBar.js'
import FormattedTime from './formattedTime.js'

import IconPlay from '../../svgs/icons/icon-play.svg'
import IconVolume from '../../svgs/icons/icon-volume.svg'

import './index.css'

class Player extends Component {
  render() {

    return (
      <div className='djn-player'>
        <ProgressBar
          isEnabled
          direction='HORIZONTAL'
          value={0.5}
        />
        <div className='inner'>
          <div className='play-button'>
            <IconPlay className='icon' width='48px' height='48px' fill='inherit'/>
          </div>
          <div className='album-art'>
          </div>
          <div className='album-meta'>
            <div className='track-name'>T</div>
            <div className='album'>
              <span className='artist-name'>Tycho - </span>
              <span className='album-name'>ボーナス・トラック</span>
            </div>
          </div>
          <div className='djn-volumeSlider'>
            <IconVolume className='icon'/>
            <ProgressBar
              isEnabled
              direction='HORIZONTAL'
              value={0.5}
            />
          </div>
          <div className='timestamp font-mono'>
            <FormattedTime numSeconds={60} className='font-mono'/> / <FormattedTime numSeconds={120} className='font-mono text-grey'/>
          </div>
          <Button type='translucent-dark' text='Buy Album'/>
        </div>
      </div>
    )
  }
}

export default Player
