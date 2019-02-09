import React from 'react'

import Navigation from './navigation.js'

const withNavigation = (Child) => {
  return class WithNavigation extends React.Component {
    static async getInitialProps(ctx) {
      if (Child.getInitialProps) {
        return Child.getInitialProps(ctx)
      }
    }

    render() {
      return (
        <>
          <Navigation />
          <Child {...this.props} />
        </>
      )
    }
  }
}

export default withNavigation
