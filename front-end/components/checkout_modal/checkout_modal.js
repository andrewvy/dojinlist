import React, { PureComponent } from 'react'
import { injectStripe } from 'react-stripe-elements'
import { CardNumberElement, CardExpiryElement, CardCVCElement, PostalCodeElement } from 'react-stripe-elements'

import Button from '../button'

class CheckoutModal extends PureComponent {
  onSubmit = (ev) => {
    ev.preventDefault()

    this.props.stripe.createToken({name: 'Test'}).then(({token}) => {
      console.log('Token Received:', token)
    });
  }

  render() {
    return (
      <div className='djn-checkoutModal container limit-screen w-2/3'>
          <form onSubmit={this.onSubmit}>
            <div>Checkout</div>
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

            <Button type='translucent' text='Purchase' onClick={() => {}} />
          </form>
      </div>
    )
  }
}

export default injectStripe(CheckoutModal)
