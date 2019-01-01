import Link from 'next/link'

const Footer = () => (
  <>
    <footer>
      <Link href='/'><a>Home</a></Link>
      <a href='https://twitter.com/dojinlist' target='_blank'>Twitter</a>
      <a href='mailto:team@dojinlist.co'>Contact us</a>
      <Link href='/terms'><a>Terms</a></Link>
      <a href='/privacy'>Privacy</a>
      <a href='/cookie-policy'>Cookie Policy</a>
    </footer>
  </>
)

export default Footer
