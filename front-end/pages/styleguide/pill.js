import React from 'react'

import Pill from '../../components/pill'
import Page from '../../layouts/main.js'

import { HeaderStyles, SubheaderStyles } from '../../lib/styleguideUtils.js'

const PillPage = (props) => {
  return (
    <Page>
      <div className='container limit-screen p-8'>
        <h1 className={HeaderStyles}>Pill</h1>
        <div className='my-8'>
          <div className={SubheaderStyles}>Blue</div>
          <Pill
            lightColor='blue-lighter'
            darkColor='blue'
            title='Notes'
            description='From the editors'
          />
        </div>
        <div className='my-8'>
          <div className={SubheaderStyles}>Red</div>
          <Pill
            lightColor='red-light'
            darkColor='red'
            title='Recommended'
            description='Explore similar sounds'
          />
        </div>
        <div className='my-8'>
          <div className={SubheaderStyles}>Grey</div>
          <Pill
            lightColor='grey-light'
            darkColor='grey'
            title='New'
            description='Recently released albums'
          />
        </div>
      </div>
    </Page>
  )
}

export default PillPage
