import React from 'react'

import Navigation from '../../components/navigation/navigation'
import Page from '../../layouts/main.js'

import { Action, HeaderStyles, SubheaderStyles } from '../../lib/styleguideUtils.js'

const NavigationPage = (props) => {
  return (
    <Page>
      <div className='container limit-screen p-8'>
        <h1 className={HeaderStyles}>Navigation</h1>
        <div className='my-8'>
          <div className={SubheaderStyles}>Primary</div>
          <Navigation />
        </div>
      </div>
    </Page>
  )
}

export default NavigationPage
