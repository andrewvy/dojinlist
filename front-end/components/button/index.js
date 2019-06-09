import React from 'react'
import classnames from 'classnames'

import Spinner from '../spinner'

import DownloadIcon from '../../svgs/icons/icon-download.svg'
import LinkIcon from '../../svgs/icons/icon-link.svg'
import PlusIcon from '../../svgs/icons/icon-plus.svg'
import SearchIcon from '../../svgs/icons/icon-search.svg'

import './index.css'

const ButtonIcon = icon => {
  let IconComponent = () => {
    return null
  }

  switch (icon) {
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

const Button = ({ text, icon, type, onClick, className, disabled,  isLoading }) => {
  const IconComponent = ButtonIcon(icon)

  const classname = classnames(
    'djn-button',
    `djn-button-${type}`,
    'font-sans',
    'font-black',
    'select-none',
    'cursor-pointer',
    className,
    {
      'disabled': disabled,
      'is-loading': isLoading
    }
  )

  return (
    <button
      className={classname}
      onClick={(e) => !disabled ? onClick(e) : null}
    >
      {!isLoading && text}
      {!isLoading && <IconComponent fill='inherit' className='icon' />}
      {isLoading && <Spinner size='small' />}
    </button>
  )
}

Button.defaultProps = {
  disabled: false,
  isLoading: false,
  onClick: () => {}
}

export default Button
