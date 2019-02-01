import React from 'react'
import Link from 'next/link'

import WhiteLogo from '../../svgs/brand/standalone_white_icon.svg'

import DiscordLogo from '../../svgs/social/discord.svg'
import TwitterLogo from '../../svgs/social/twitter.svg'

import './index.css'

const Footer = () => (
  <footer className='djn-footer'>
    <div className='upper'>
      <div className='left'>
        <p className='description'>
          Friendly music marketplace for self-published creators. An eccletic beat on
          the underworld of doujin music, electronic culture, and the ins-and-outs of
          running an independent music community.
        </p>
      </div>
      <div className='right'>
        <div className='col-1'>
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
            <Link href='/'><a>Sign Up</a></Link>
          </div>
        </div>

        <div className='col-2'>
          <div className='link'>
            <Link href='/terms'><a>Terms</a></Link>
          </div>
          <div className='link'>
            <a href='/privacy'>Privacy</a>
          </div>
          <div className='link'>
            <a href='/cookie-policy'>Cookie Policy</a>
          </div>
        </div>
      </div>

      <div className='logo'>
        <WhiteLogo />
      </div>
    </div>

    <div className='lower'>
      <div className='social'>
        <a href='https://twitter.com/dojinlist' target='_blank'><TwitterLogo /></a>
        <a href='https://discord.gg/HT4d9nR' target='_blank'><DiscordLogo /></a>
      </div>
      <p>
        Copyright ©  2019. Dojinlist LLC. All Rights Reserved.
      </p>
    </div>
  </footer>
)

export default Footer
