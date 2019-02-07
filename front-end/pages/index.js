import React, {PureComponent} from 'react';
import Link from 'next/link';
import {Query} from 'react-apollo';

import {AuthConsumer} from '../contexts/auth.js';

import Spinner from '../components/spinner';
import withNavigation from '../components/navigation';
import Pill from '../components/pill'
import BlogTeaser from '../components/blog_teaser'

import Page from '../layouts/main.js';

import HelloWorldPost from '../posts/hello-world.js'

const Styles = () => (
  <style jsx="true">
    {`
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

class IndexPage extends PureComponent {
  render() {
    return (
      <Page className='bg-white'>
        <div className="container content limit-screen my-8 w-2/3">
          <div className='main font-bold text-4xl text-center my-8'>
            A marketplace to discover and buy dōjin music.
          </div>
          <Pill
            lightColor='red-light'
            darkColor='red'
            title='Blog'
            description='From the developers'
          />
          <BlogTeaser post={HelloWorldPost} />
          <Pill
            lightColor='blue-lighter'
            darkColor='blue'
            title='Recent'
            description='New albums added'
          />
        </div>
        <Styles />
      </Page>
    );
  }
}

export default withNavigation(IndexPage);
