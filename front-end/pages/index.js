import React from 'react';
import Link from 'next/link';
import {Query} from 'react-apollo';

import {AuthConsumer} from '../contexts/auth.js';
import Spinner from '../components/spinner';

import Page from '../layouts/main.js';

import Logo from '../svgs/brand/blue_bg_fill_wordmark.svg';

const Styles = () => (
  <style jsx="true">
    {`
      body {
        margin: 0;
        text-align: center;
      }

      .page {
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
      }

      .navigation {
        padding-top: 20px;
        animation: 0.5s ease-out 0s 1 slideIn;
      }

      .content {
        color: white;
      }

      @keyframes slideIn {
        0% {
          opacity: 0;
          transform: translateY(-20px);
        }
        100% {
          opacity: 1;
          transform: translateY(0px);
        }
      }

      .logo {
        width: 200px;
      }

      .content {
        animation: 0.5s ease-out 0s 1 slideIn;
        padding-top: 20px;
      }

      .content em {
        user-select: none;
      }
    `}
  </style>
);

class IndexPage extends React.Component {
  render() {
    return (
      <Page className='bg-blue-darker'>
        <nav className="navigation">
          <section className="container">
            <Logo className="logo" />
          </section>
        </nav>
        <div className="container content">
          <p>
            <em>early 2019</em>
          </p>
          <AuthConsumer>
            {({isAuthed}) => {
              if (isAuthed) {
                return (
                  <p>
                    <span>Logged in? </span>
                    <Link href="/profile">
                      <a>Go to your profile.</a>
                    </Link>
                  </p>
                );
              } else {
                return '';
              }
            }}
          </AuthConsumer>
        </div>
        <Styles />
      </Page>
    );
  }
}

export default IndexPage;
