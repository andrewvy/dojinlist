import React from 'react'

import SearchIcon from '../../svgs/icons/icon-search.svg'

import './index.css'

const Search = ({placeholder, ...props}) => (
  <div className='djn-search'>
    <SearchIcon fill='inherit' className='icon'/>
    <input
      className='input'
      type='text'
      placeholder={placeholder}
      {...props}
    />
  </div>
)

export default Search
