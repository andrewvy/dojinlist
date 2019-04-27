import React, { useState, useEffect } from 'react'
import { Link } from '../../routes.js'
import { withRouter } from 'next/router'

import { AuthConsumer } from '../../contexts/auth.js'
import { MeConsumer } from '../../contexts/me.js'

import UserDropdown from './user_dropdown'

import './navigation.css'

import Logo from '../../svgs/brand/white_bg_fill_wordmark.svg'

const NavLink = ({ router, href, text }) => (
  <li className={router.pathname === href ? 'active' : ''}>
    <Link href={href}>
      <a>{text}</a>
    </Link>
  </li>
)

const Navigation = ({ router }) => {
  const [shouldShowMenu, toggleMenu] = useState(false)

  return (
    <AuthConsumer>
      {({ isAuthed }) => (
        <MeConsumer>
          {({ me }) => (
            <nav className='djn-navigation'>
              <div className='djn-navigation-inner mx-auto px-32'>
                <div className='logo'>
                  <Link href='/'>
                    <a>
                      <Logo />
                    </a>
                  </Link>
                </div>
                <div className='user-controls'>
                  <NavLink router={router} href='/' text='Discover' />

                  {!isAuthed && (
                    <NavLink router={router} href='/login' text='Login' />
                  )}

                  {isAuthed && me && (
                    <nav
                      className='user-avatar'
                      aria-label='View profile and more'
                      aria-haspopup='menu'
                      tabindex={0}
                      onFocus={() => toggleMenu(true)}
                      onMouseEnter={() => toggleMenu(true)}
                      onMouseLeave={() => toggleMenu(false)}
                    >
                      <div>
                        <img className='user-avatar-image' src={me.avatar} />
                        {shouldShowMenu && <UserDropdown />}
                      </div>
                    </nav>
                  )}
                </div>
              </div>
            </nav>
          )}
        </MeConsumer>
      )}
    </AuthConsumer>
  )
}

export default withRouter(Navigation)
