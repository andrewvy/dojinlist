import React, { Component } from 'react'

import Player from '../../components/player'
import PlayerWrapper from '../../components/player/wrapper.js'
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
