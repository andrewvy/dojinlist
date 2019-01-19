import React from 'react'
import App, { Container } from 'next/app'
import Head from 'next/head'
import { ApolloProvider } from 'react-apollo'

import withApollo from '../lib/withApollo'
import { AuthProvider } from '../contexts/auth.js'
import { MeProvider } from '../contexts/me.js'

import '../styles/index.css'
import '../styles/form.css'

const fathomScript = `
(function(f, a, t, h, o, m){
  a[h]=a[h]||function(){
    (a[h].q=a[h].q||[]).push(arguments)
  };
  o=f.createElement('script'),
  m=f.getElementsByTagName('script')[0];
  o.async=1; o.src=t; o.id='fathom-script';
  m.parentNode.insertBefore(o,m)
})(document, window, '//andrewvy.usesfathom.com/tracker.js', 'fathom');
fathom('set', 'siteId', 'AUTHL');
fathom('trackPageview');
`

class MainApp extends App {
  static async getInitialProps({ Component, router, ctx }) {
    let pageProps = {}

    if (Component.getInitialProps) {
      pageProps = await Component.getInitialProps(ctx)
    }

    return { pageProps }
  }

  render() {
    const { Component, pageProps, apolloClient } = this.props

    return (
      <Container>
        <Head>
          <title>dojinlist | Doujin Music Marketplace and Community</title>
          <meta charSet='utf-8' />
          <meta name='viewport' content='width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no' />
          <meta name='description' content='Dojinlist is your friendly international doujin music marketplace and community.' />
          <meta property='og:title' content='dojinlist: International Doujin Music Marketplace and Community' />
          <meta property='og:description' content='dojinlist is an international music marketplace and community for self-published creators.' />
          <meta property='og:url' content='https://dojinlist.co' />

          <link rel="icon" type="image/png" sizes="16x16" href='/static/favicon-16x16.png' />
          <link rel="icon" type="image/png" sizes="32x32" href='/static/favicon-32x32.png' />
          <link rel="icon" type="image/png" sizes="64x64" href='/static/favicon-64x64.png' />
          <link href="https://fonts.googleapis.com/css?family=Noto+Sans+JP" rel="stylesheet" />

          <script type="text/javascript">{`var _iub = _iub || []; _iub.csConfiguration = {"lang":"en","siteId":1445725,"cookiePolicyId":80104253, "banner":{ "textColor":"white","backgroundColor":"black" } }; `}</script>

          {
            TRACKING_ENABLED &&
            <>
              <script type="text/javascript" src="//cdn.iubenda.com/cookie_solution/safemode/iubenda_cs.js" charset="UTF-8" async></script>
              <script>
                {fathomScript}
              </script>
            </>
          }
        </Head>
        <ApolloProvider client={apolloClient}>
          <AuthProvider>
            <MeProvider>
              <Component {...pageProps} />
            </MeProvider>
          </AuthProvider>
        </ApolloProvider>
      </Container>
    )
  }
}

export default withApollo(MainApp)
