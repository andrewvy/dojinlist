import React, { PureComponent } from 'react'
import { injectStripe } from 'react-stripe-elements'

import { CardNumberElement, CardExpiryElement, CardCVCElement, PostalCodeElement } from 'react-stripe-elements'

import Button from '../button'

class CheckoutModal extends PureComponent {
  static defaultProps = {
    onCreateToken: () => {}
  }

  state = {
    currentPageIndex: 0,
    formData: {
      email: ''
    }
  }

  onSubmit = (ev) => {
    const { formData } = this.state
    const { onCreateToken } = this.props

    ev.preventDefault()

    this.props.stripe.createToken({name: 'Test'}).then((response) => {
      if (response.error) {
      } else {
        onCreateToken({
          token: response.token,
          email: formData.email,
        })
      }
    });
  }

  onChange = (field) => (ev) => {
    const { formData } = this.state

    this.setState({
      formData: {
        ...formData,
        [field]: ev.target.value
      }
    })
  }

  render() {
    const { isAuthed } = this.props
    const { formData } = this.state

    return (
      <div className='djn-checkoutModal container limit-screen w-3/4'>
        <form onSubmit={this.onSubmit} className='flex flex-row'>
          <div className='w-full m-8 p-8 bg-white rounded shadow'>
            <p className='font-bold text-blue-darker'>Payment Details</p>
            <p className='text-grey'>
              All payments are processed directly through Stripe, no card information is passed
              to our servers. Once your purchase has been completed, you will be able to access a
              download page with your purchased album.
            </p>

            <p className='font-bold text-blue-darker'>Contact Information</p>

            {
              isAuthed ?
                <div>Your purchase will be associated with your account.</div>
              :
                <fieldset>
                  <label htmlFor='email'>Email Address</label>
                  <input type='email' placeholder='Email' required onChange={this.onChange('email')} value={formData.email} />
                </fieldset>
            }

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

          <div className='w-full m-8'>
            <div className='p-8 bg-white shadow rounded'>
              <p className='font-bold text-blue-darker'>Summary</p>
              <div className='djn-lineItem my-4 flex flex-row'>
                <div className='font-bold text-blue-darker w-full'>Subtotal</div>
                <div className='font-bold text-blue-darker right w-full'>¥2500 JPY</div>
              </div>
              <div className='djn-lineItem my-4 flex flex-row'>
                <div className='font-bold text-blue-darker w-full'>Tax</div>
                <div className='font-bold text-blue-darker right w-full'>¥2500 JPY</div>
              </div>
              <div className='djn-lineItem my-4 flex flex-row'>
                <div className='font-bold text-blue-darker w-full'>Grand Total</div>
                <div className='font-bold text-blue-darker right w-full'>¥2500 JPY</div>
              </div>
            </div>
            <Button type='primary' text='Purchase' className='w-full my-8'/>
          </div>

        </form>
      </div>
    )
  }
}

export default injectStripe(CheckoutModal)
