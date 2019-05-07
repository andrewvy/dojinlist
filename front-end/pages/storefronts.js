import React, { useState, useEffect, useRef } from 'react'
import { Mutation } from 'react-apollo'

import { MeConsumer } from '../contexts/me'
import UploadAvatarMutation from '../mutations/storefronts/upload_avatar'
import UploadBannerMutation from '../mutations/storefronts/upload_banner'

import { Link } from '../routes.js'

import withOnlyAuthenticated from '../lib/onlyAuthenticated'

import Page from '../layouts/main.js'

import withNavigation from '../components/navigation'
import Spinner from '../components/spinner'
import Button from '../components/button'
import Uploader from '../components/uploader'

import Avatar from '../components/avatar'

import IconShoppingCart from '../svgs/icons/icon-shopping-cart.svg'
import IconCheveronDown from '../svgs/icons/icon-cheveron-down.svg'
import IconViewColumn from '../svgs/icons/icon-view-column.svg'
import IconMusicAlbum from '../svgs/icons/icon-music-album.svg'
import IconCog from '../svgs/icons/icon-cog.svg'

import './storefronts.css'

const Loader = () => (
  <div className='container vertical-center'>
    <Spinner color='blue-darker' size='large' />
  </div>
)

const hasConnectedStripeAccount = me => {
  return me.stripeAccount && me.stripeAccount.stripeUserId
}

const Dropdown = ({ items, onClick, onBlur, isOpen, onOpen, currentItem }) => {
  const node = useRef()

  const handleClick = e => {
    if (node.current.contains(e.target)) {
      return
    }

    onBlur()
  }

  useEffect(() => {
    document.addEventListener('mousedown', handleClick)

    return () => {
      document.removeEventListener('mousedown', handleClick)
    }
  }, [node])

  return (
    <div ref={node}>
      <div
        className='appearance-none cursor-pointer w-full bg-white text-grey-darker py-4 rounded leading-tight focus:outline-none focus:bg-white focus:border-grey'
        onClick={onOpen}
      >
        <span className='p-2 rounded-full bg-white shadow'>
          <IconShoppingCart fill='#2F313D' />
        </span>
        <span className='ml-2'>
          {currentItem && currentItem.displayName}
          {!currentItem && 'Select a storefront'}
        </span>

        <span>
          <IconCheveronDown
            fill='#2F313D'
            className='relative'
            style={{ top: 5, left: 6 }}
          />
        </span>
      </div>

      <div
        className={`absolute bg-grey-lighter w-1/6 z-10 transition rounded ${
          isOpen ? 'visible opacity-100' : 'invisible opacity-0'
        }`}
      >
        <ul className='list-reset'>
          {items.map(item => (
            <li
              key={item.id}
              className='hover:bg-grey m-0 p-2 cursor-pointer'
              onClick={() => onClick(item)}
            >
              {item.displayName}
            </li>
          ))}

          <li className='m-0 p-2 cursor-pointer'>Add a storefront</li>
        </ul>
      </div>
    </div>
  )
}

const StorefrontsPage = ({ me }) => {
  const [currentStorefront, setCurrentStorefront] = useState(
    me.storefronts[0]
  )

  const [isOpen, setMenuVisibility] = useState(false)

  return (
    <div className='djn-storefrontsPage mx-auto p-16'>
      <div className='left w-1/6 flex flex-col'>
        <Avatar user={me} width={'auto'} height={'auto'} className='ml-2' />

        <Dropdown
          items={me.storefronts}
          isOpen={isOpen}
          currentItem={currentStorefront}
          onClick={storefront => setCurrentStorefront(storefront)}
          onBlur={() => setMenuVisibility(false)}
          onOpen={() => setMenuVisibility(!isOpen)}
        />

        <ul className='navigation appearance-none list-reset my-6'>
          <li>
            <IconViewColumn
              fill='#FF6D6B'
              className='relative'
              style={{ top: 5, left: 6 }}
            />
            <span className='ml-4'>Dashboard</span>
          </li>
          <li>
            <IconMusicAlbum
              fill='#1F28577'
              className='relative'
              style={{ top: 5, left: 6 }}
            />
            <span className='ml-4'>Albums</span>
          </li>
        </ul>

        <ul className='navigation appearance-none list-reset my-6'>
          <li>
            <IconCog
              fill='#1F28577'
              className='relative'
              style={{ top: 5, left: 6 }}
            />
            <span className='ml-4'>Settings</span>
          </li>
        </ul>
      </div>
      <div>
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
