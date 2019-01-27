import React from 'react'

import Search from '../../components/search'
import Page from '../../layouts/main.js'

const Action = (name) => () => console.log(name)

const HeaderStyles = 'uppercase text-grey font-mono'
const SubheaderStyles = `${HeaderStyles} my-4`

const ButtonPage = (props) => {
  return (
    <Page>
      <div className='container limit-screen p-8'>
        <h1 className={HeaderStyles}>Search</h1>
        <div className='my-8'>
          <div className={SubheaderStyles}>Primary</div>
          <Search placeholder='Search' onChange={Action('Search')}/>
        </div>
      </div>
    </Page>
  )
}

export default ButtonPage
