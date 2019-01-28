import React from 'react'

import ProgressBar from '../../components/player/progressBar.js'
import ProgressBarWithHover from '../../components/player/progressBarWithHover.js'

import Page from '../../layouts/main.js'

import { HeaderStyles, SubheaderStyles } from '../../lib/styleguideUtils.js'

const PlayerPage = (props) => {
  return (
    <Page>
      <div className='container limit-screen p-8'>
        <h1 className={HeaderStyles}>Slider</h1>
        <div className='my-8'>
          <div className={SubheaderStyles}>Blue</div>
          <ProgressBar
            isEnabled
            direction='HORIZONTAL'
            value={0.5}
            onChange={() => {}}
            onIntent={(intent) => console.log(intent)}
          />
        </div>
        <div className='my-8'>
          <div className={SubheaderStyles}>Blue</div>
          <ProgressBarWithHover
            duration={25}
          />
        </div>
      </div>
    </Page>
  )
}

export default PlayerPage
