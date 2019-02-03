import React from 'react'
import Link from 'next/link'
import { AuthConsumer } from '../../contexts/auth.js'
import { MeConsumer } from '../../contexts/me.js'

import './navigation.css'

import Logo from '../../svgs/brand/white_bg_fill_wordmark.svg'

const Styles = () => (
  <style jsx>{`
  `}</style>
)

const Navigation = () => (
  <AuthConsumer>
    {({isAuthed}) => (
      <MeConsumer>
        {({}) => (
          <nav className='djn-navigation limit-screen mx-auto'>
            <div className='logo'>
              <Link href='/'>
                <a>
                  <Logo />
                </a>
              </Link>
            </div>
            <div className='user-controls'>
              <li><Link href='/'>Discover</Link></li>
              <li><Link href='/'>Artists</Link></li>
              <li><Link href='/'>Album</Link></li>
              <li><Link href='/logout'><a>Logout</a></Link></li>
            </div>
            <Styles />
          </nav>
        )}
      </MeConsumer>
    )}
  </AuthConsumer>
)

export default Navigation
