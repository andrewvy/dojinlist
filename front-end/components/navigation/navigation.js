import React from 'react'
import Link from 'next/link'
import { withRouter } from 'next/router'

import { AuthConsumer } from '../../contexts/auth.js'
import { MeConsumer } from '../../contexts/me.js'

import './navigation.css'

import Logo from '../../svgs/brand/white_bg_fill_wordmark.svg'

const Styles = () => (
  <style jsx>{`
  `}</style>
)

const NavLink = ({ router, href, text }) => (
  <li className={router.pathname === href ? 'active' : ''}>
    <Link href={href}>
      {text}
    </Link>
  </li>
)

const Navigation = ({router}) => (
  <AuthConsumer>
    {({isAuthed}) => (
      <MeConsumer>
        {({}) => (
          <nav className='djn-navigation'>
            <div className='djn-navigation-inner limit-screen mx-auto'>
              <div className='logo'>
                <Link href='/'>
                  <a>
                    <Logo />
                  </a>
                </Link>
              </div>
              <div className='user-controls'>
                <NavLink router={router} href='/' text='Discover' />
                <NavLink router={router} href='/logout' text='Logout' />
              </div>
            </div>
            <Styles />
          </nav>
        )}
      </MeConsumer>
    )}
  </AuthConsumer>
)

export default withRouter(Navigation)
