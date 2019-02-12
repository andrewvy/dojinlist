import { Elements } from 'react-stripe-elements'

import CheckoutModal from './checkout_modal.js'

const WrappedCheckoutModal = (props) => (
  <Elements>
    <CheckoutModal {...props} />
  </Elements>
)

export default WrappedCheckoutModal
