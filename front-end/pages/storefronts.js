import React, { useState } from 'react'

import { MeConsumer } from '../contexts/me.js'

import { Link } from '../routes.js'

import withOnlyAuthenticated from '../lib/onlyAuthenticated'

import Page from '../layouts/main.js'

import withNavigation from '../components/navigation'
import Spinner from '../components/spinner'
import Button from '../components/button'

import './storefronts.css'

const Loader = () => (
  <div className='container vertical-center'>
    <Spinner color='blue-darker' size='large' />
  </div>
)

const StorefrontTile = ({ storefront, currentStorefront }) => {
  const isActive = storefront.id === (currentStorefront && currentStorefront.id)

  return (
    <div
      className={`djn-storefrontTile font-black p-4 w-full rounded ${
        isActive ? 'active' : ''
      }`}
    >
      <div>{storefront.displayName}</div>
    </div>
  )
}

const StorefrontsPage = ({ me }) => {
  const [currentStorefront, setCurrentStorefront] = useState(me.storefronts[0])

  return (
    <div className='djn-storefrontsPage limit-screen mx-auto py-16'>
      <h1 className='text-2xl text-grey font-mono my-8'>Your storefronts</h1>

      <div className='dashboard-grid'>
        <div className='storefronts'>
          {me.storefronts.map(storefront => (
            <StorefrontTile
              key={storefront.id}
              storefront={storefront}
              currentStorefront={currentStorefront}
              onClick={() => setCurrentStorefront(storefront)}
            />
          ))}

          <Button text='Create a storefront' type='primary' icon='plus' />
        </div>

        <div className='dashboard-inner w-full'>
          {currentStorefront ? (
            <>
              <Link route='storefront' params={{storefront_slug: currentStorefront.slug}}>
                <Button className='visit-page-btn' text='Visit page' type='translucent'/>
              </Link>
              <h2 className='header text-2xl text-grey font-mono'>{currentStorefront.displayName}</h2>
              <div>
                Link a stripe account
              </div>
            </>
          ) : (
            <span className='text-grey font-mono center'>
              Select a storefront from the left
            </span>
          )}
        </div>
      </div>
    </div>
  )
}

const Storefronts = () => (
  <Page>
    <MeConsumer>
      {({ isLoading, me }) => {
        if (isLoading) {
          return <Loader />
        } else {
          return <StorefrontsPage me={me} />
        }
      }}
    </MeConsumer>
  </Page>
)

export default withOnlyAuthenticated(withNavigation(Storefronts))
