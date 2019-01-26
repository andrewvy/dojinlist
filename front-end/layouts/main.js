import Footer from '../components/footer'

export default ({ children, className }) => (
  <>
    <div className={`page mx-auto ${className}`}>
      { children }
    </div>
    <Footer />
  </>
)
