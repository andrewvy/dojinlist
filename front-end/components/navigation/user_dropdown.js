import { Link } from '../../routes.js'

import './user_dropdown.css'

const UserDropdown = () => (
  <div className='djn-userDropdown shadow-lg rounded'>
    <div className='menu-item rounded'>
      <Link href='/dashboard/purchases'>
        <a>My music</a>
      </Link>
    </div>
    <div className='menu-item rounded'>
      <Link href='/dashboard'>
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
