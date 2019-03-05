import './index.css'

const CheckoutSuccess = ({ album }) => (
  <div className='djn-checkoutSuccess w-full p-8 bg-white rounded shadow'>
    <h2 className='gradient'>Thank you for your purchase!</h2>
    <div className='album'>
      <div className='album-name'>{album.title}</div>
      <div className='album-artist'>{album.artistName}</div>
    </div>
    <p>
      Order ID: <span className='orderId'>#A4EF00</span>
    </p>
    <p>
      Your purchase is now added to your music collection, and will always be
      available for unlimited streaming & downloading.
    </p>
  </div>
)

export default CheckoutSuccess
