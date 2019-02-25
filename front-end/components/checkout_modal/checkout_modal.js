import React, { PureComponent } from 'react'
import { injectStripe } from 'react-stripe-elements'
import { CardNumberElement, CardExpiryElement, CardCVCElement, PostalCodeElement } from 'react-stripe-elements'

import Button from '../button'

class CheckoutModal extends PureComponent {
  static defaultProps = {
    onCreateToken: () => {}
  }

  state = {
    email: ''
  }

  onSubmit = (ev) => {
    const { email } = this.state
    const { onCreateToken } = this.props

    ev.preventDefault()

    this.props.stripe.createToken({name: 'Test'}).then(({token}) => {
      onCreateToken({
        token,
        email,
      })
    });
  }

  onChange = (field) => (ev) => {
    this.setState({
      [field]: ev.target.value
    })
  }

  render() {
    const { isAuthed } = this.props
    const { email } = this.state

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

            {
              !isAuthed &&
              <fieldset>
                <label htmlFor='email'>Email Address</label>
                <input type='email' placeholder='Email' required onChange={this.onChange('email')} value={email} />
              </fieldset>
            }

            <Button type='translucent' text='Purchase'/>
          </form>
      </div>
    )
  }
}

export default injectStripe(CheckoutModal)
