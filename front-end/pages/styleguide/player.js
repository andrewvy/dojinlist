import React from 'react'

import Player from '../../components/player'
import ProgressBar from '../../components/player/progressBar.js'

import Page from '../../layouts/main.js'

import { HeaderStyles, SubheaderStyles } from '../../lib/styleguideUtils.js'

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
          <Player
          />
        </div>
      </div>
    </Page>
  )
}

export default PlayerPage
