import Footer from '../components/footer'
import withNavigation from '../components/navigation'

const MainLayout = ({ children, className }) => (
  <>
    <div className={`page mx-auto ${className}`}>
      { children }
    </div>
    <Footer />
  </>
)

export default withNavigation(MainLayout)
