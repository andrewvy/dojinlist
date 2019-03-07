import './index.css'

const CheckoutSuccess = ({ album, transactionId }) => (
  <div className='djn-checkoutSuccess w-full p-8 bg-white rounded shadow'>
    <h2 className='gradient'>Thank you for your purchase!</h2>
    <div className='album'>
      <div className='album-name'>{album.title}</div>
      <div className='album-artist'>{album.artistName}</div>
    </div>
    <p>
      Transaction ID: <span className='transactionId'>#{transactionId}</span>
    </p>
    <p>
      Your purchase is now added to your music collection, and will always be
      available for unlimited streaming & downloading.
    </p>
  </div>
)

export default CheckoutSuccess
