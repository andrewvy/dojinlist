import React, { useState, useEffect } from 'react'
import { Link } from '../../routes.js'
import { withRouter } from 'next/router'

import { AuthConsumer } from '../../contexts/auth.js'
import { MeConsumer } from '../../contexts/me.js'

import UserDropdown from './user_dropdown'
import Button from '../button'
import Avatar from '../avatar'

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
                <ul className='user-controls'>
                  <NavLink router={router} href='/' text='Discover' />

                  {!isAuthed && (
                    <li>
                      <Link href='/register'>
                        <Button type='primary' text='Sign Up' />
                      </Link>
                    </li>
                  )}

                  {!isAuthed && (
                    <li>
                      <Link href='/login'>
                        <Button type='translucent' text='Sign In' />
                      </Link>
                    </li>
                  )}

                  {isAuthed && me && (
                    <nav
                      className='user-avatar'
                      aria-label='View profile and more'
                      aria-haspopup='menu'
                      tabIndex={0}
                      onFocus={() => toggleMenu(true)}
                      onMouseEnter={() => toggleMenu(true)}
                      onMouseLeave={() => toggleMenu(false)}
                    >
                      <Avatar user={me} />
                      {shouldShowMenu && <UserDropdown />}
                    </nav>
                  )}
                </ul>
              </div>
            </nav>
          )}
        </MeConsumer>
      )}
    </AuthConsumer>
  )
}

export default withRouter(Navigation)
