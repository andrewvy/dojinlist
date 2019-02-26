import Button from '../../button'

import { CardNumberElement, CardExpiryElement, CardCVCElement, PostalCodeElement } from 'react-stripe-elements'

const PaymentPage = () => (
  <div className='djn-checkoutPage'>
    Payment Page

    <fieldset>
      <label htmlFor='card-number'>Card Number</label>
      <CardNumberElement id='card-number'/>
    </fieldset>
    <fieldset>
      <label htmlFor='card-expiry'>Card Expiry</label>
      <CardExpiryElement id='card-expiry'/>
    </fieldset>
    <fieldset>
      <label htmlFor='card-cvc'>CVC</label>
      <CardCVCElement id='card-cvc'/>
    </fieldset>
    <fieldset>
      <label htmlFor='postal-code'>Postal Code</label>
      <PostalCodeElement id='postal-code'/>
    </fieldset>
  </div>
)

export default PaymentPage
