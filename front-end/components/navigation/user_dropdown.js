import { Link } from '../../routes.js'

import './user_dropdown.css'

const UserDropdown = () => (
  <div className='djn-userDropdown shadow-lg rounded'>
    <div className='menu-item rounded'>
      <Link href='/music'>
        <a>My music</a>
      </Link>
    </div>
    <div className='menu-item rounded'>
      <Link href='/storefronts'>
        <a>My storefronts</a>
      </Link>
    </div>
    <div className='menu-item rounded'>
      <Link href='/profile'>
        <a>My profile settings</a>
      </Link>
    </div>
    <div className='menu-item rounded'>
      <Link href='/logout'>
        <a>Log out</a>
      </Link>
    </div>
  </div>
)

export default UserDropdown
