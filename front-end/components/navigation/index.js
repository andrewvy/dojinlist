import React from 'react'
import Link from 'next/link'
import { AuthConsumer } from '../../contexts/auth.js'
import { MeConsumer } from '../../contexts/me.js'

import Logo from '../../svgs/brand/white_bg_fill_wordmark.svg'

const Styles = () => (
  <style jsx>{`
    .navigation {
      height: 60px;
      display: flex;
      flex-direction: row;
      box-sizing: border-box;
    }

    .logo {
      margin-right: 24px;
      max-width: 184px;
    }

    .logo,
    .user-controls {
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .pages {
      padding-left: 12px;
    }

    .pages a {
      padding: 0 12px;
    }

    .user-controls {
      height: 100%;
      align-self: flex-end;
      margin-left: auto;
    }
  `}</style>
)

const Navigation = () => (
  <AuthConsumer>
    {({isAuthed}) => (
      <MeConsumer>
        {({}) => (
          <nav className='navigation limit-screen mx-auto'>
            <span className='logo'><Link href='/'><a><Logo /></a></Link></span>
            <span className='pages border border-solid border-grey-lighter'>
            </span>
            <div className='user-controls'>
              {
                isAuthed &&
                <Link href='/logout'><a>Logout</a></Link>
              }
            </div>
            <Styles />
          </nav>
        )}
      </MeConsumer>
    )}
  </AuthConsumer>
)

const withNavigation = (Child) => (props) => (
  <>
    <Navigation />
    <Child {...props} />
  </>
)

export default withNavigation
