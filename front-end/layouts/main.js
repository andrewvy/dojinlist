import Footer from '../components/footer'

export default ({ children }) => (
  <>
    <div className='page limit-screen mx-auto'>
      { children }
    </div>
    <Footer />
  </>
)
