import React from 'react'

import Navigation from './navigation.js'

const withNavigation = (Child) => (props) => (
  <>
    <Navigation />
    <Child {...props} />
  </>
)

export default withNavigation
