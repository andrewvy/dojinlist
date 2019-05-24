import React, {PureComponent} from 'react';
import Link from 'next/link';
import {Query} from 'react-apollo';

import { i18n, withNamespaces } from '../lib/i18n'

import {AuthConsumer} from '../contexts/auth.js';

import Spinner from '../components/spinner';
import Pill from '../components/pill'
import BlogTeaser from '../components/blog_teaser'

import Page from '../layouts/main.js';

import HelloWorldPost from '../posts/hello-world.js'

import './index.css'

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
  static async getInitialProps() {
    return {
      namespacesRequired: ['common'],
    }
  }

  render() {
    const { t } = this.props

    return (
      <Page className='bg-white'>
        <div className="container content">
          <div className='djn-hero main text-center py-40 text-blue-dark'>
            <div className='font-bold text-4xl'>{t('hero')}</div>
            <div className='font-light my-8'>{t('sub-hero')}</div>
          </div>

          <div className='container bg-white limit-screen w-2/3 my-8'>
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

export default withNamespaces('common')(IndexPage)
