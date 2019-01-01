import Link from 'next/link'

const Styles = () => (
  <style jsx>{`
    .profile-navigation {
      height: 48px;
    }

    .profile-navigation a + a {
      margin-left: 16px;
    }
  `}</style>
)

const ProfileNavigation = () => (
  <nav className='profile-navigation'>
    <div className='container'>
      <Link href='/profile'><a className='active'>Settings</a></Link>
    </div>

    <Styles />
  </nav>
)

export default ProfileNavigation
