import React from 'react'

import Button from '../../components/button'
import Page from '../../layouts/main.js'

const Action = (name) => () => console.log(name)

const HeaderStyles = 'uppercase text-grey font-mono'
const SubheaderStyles = `${HeaderStyles} my-4`

const ButtonPage = (props) => {
  return (
    <Page>
      <div className='container limit-screen p-8'>
        <h1 className={HeaderStyles}>Buttons</h1>
        <div className='my-8'>
          <div className={SubheaderStyles}>Primary</div>
          <Button type='primary' text='Buy Album' icon='plus' onClick={Action('Buy Album')}/>
        </div>
        <div className='my-8'>
          <div className={SubheaderStyles}>Translucent</div>
          <Button type='translucent' text='Download' icon='download' onClick={Action('Download')}/>
        </div>
      </div>
    </Page>
  )
}

export default ButtonPage
