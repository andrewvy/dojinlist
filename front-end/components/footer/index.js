import React from 'react'
import Link from 'next/link'

import WhiteLogo from '../../svgs/brand/standalone_white_icon.svg'

import DiscordLogo from '../../svgs/social/discord.svg'
import TwitterLogo from '../../svgs/social/twitter.svg'

import './index.css'

const Footer = () => (
  <footer className='djn-footer'>
    <div className='logo'>
      <WhiteLogo />
    </div>
    <div className='description'>
    </div>

    <div className='right'>
      <nav className='navigation'>
        <div className='link'>
          <Link href='/'><a>Discover</a></Link>
        </div>
        <div className='link'>
          <Link href='/'><a>Albums</a></Link>
        </div>
        <div className='link'>
          <Link href='/'><a>Artists</a></Link>
        </div>
        <div className='link'>
          <Link href='/terms'><a>Terms</a></Link>
        </div>
        <div className='link'>
          <a href='/privacy'>Privacy</a>
        </div>
        <div className='link'>
          <a href='/cookie-policy'>Cookie Policy</a>
        </div>
      </nav>

      <div className='social'>
        <a href='https://twitter.com/dojinlist' target='_blank'><TwitterLogo /></a>
        <a href='https://discord.gg/HT4d9nR' target='_blank'><DiscordLogo /></a>
      </div>

      <div className='copyright'>
        <p>
          Copyright ©  2019. Dojinlist LLC. All Rights Reserved.
        </p>
      </div>
    </div>
  </footer>
)

export default Footer
