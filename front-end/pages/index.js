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
      .logo {
        width: 200px;
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
        <div className="container content">
          <div className='main text-center py-40 bg-blue text-white'>
            <div className='font-bold text-4xl'>A marketplace to discover and buy dōjin music.</div>
            <div className='font-light my-8'>Find your favourite artists and music genres.</div>
          </div>

          <div className='container limit-screen w-2/3 my-8'>
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
        </div>
        <Styles />
      </Page>
    );
  }
}

export default withNavigation(IndexPage);
