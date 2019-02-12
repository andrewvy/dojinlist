import React from 'react'

import DownloadIcon from '../../svgs/icons/icon-download.svg'
import LinkIcon from '../../svgs/icons/icon-link.svg'
import PlusIcon from '../../svgs/icons/icon-plus.svg'
import SearchIcon from '../../svgs/icons/icon-search.svg'

import './index.css'

const ButtonIcon = (icon) => {
  let IconComponent = () => { return null };

  switch(icon) {
    case 'download':
      IconComponent = DownloadIcon
      break
    case 'link':
      IconComponent = LinkIcon
      break
    case 'search':
      IconComponent = SearchIcon
      break
    case 'plus':
      IconComponent = PlusIcon
      break
  }

  return IconComponent
}

const Button = ({text, icon, type, onClick, className}) => {
  const IconComponent = ButtonIcon(icon)

  return (
    <button className={`djn-button djn-button-${type} font-sans font-black select-none cursor-pointer ${className}`} onClick={onClick}>
      {text}
      <IconComponent fill='inherit' className='icon'/>
    </button>
  )
}


export default Button
