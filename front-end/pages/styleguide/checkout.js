import React from 'react'

import Page from '../../layouts/main.js'

import CheckoutSuccess from '../../components/checkout_success'

import { Action, HeaderStyles, SubheaderStyles } from '../../lib/styleguideUtils.js'

const album = {
  artistName: 'Tycho',
  title: 'ボーナス・トラック',
  coverArtUrl: 'https://s3.amazonaws.com/dojinlist-uploads/uploads/original_HV8kNla_gg8YoSVvZbEV3.png',
  tracks: [
    {
      id: 1,
      title: 'Intro',
      playLength: 330
    },
    {
      id: 2,
      title: 'Bonus Track',
      playLength: 330
    },
  ]
}

const CheckoutPage = (props) => {
  return (
    <Page>
      <div className='container limit-screen p-8'>
        <h1 className={HeaderStyles}>Successful Checkout</h1>
        <div className='my-8'>
          <div className={SubheaderStyles}>Primary</div>
          <div className='w-1/2'>
            <CheckoutSuccess album={album} />
          </div>
        </div>
      </div>
    </Page>
  )
}

export default CheckoutPage
