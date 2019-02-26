import React, { PureComponent } from 'react'
import { injectStripe } from 'react-stripe-elements'

import EmailPage from './pages/01_email.js'
import PaymentPage from './pages/02_payment.js'

import Button from '../button'

class CheckoutModal extends PureComponent {
  static defaultProps = {
    onCreateToken: () => {}
  }

  pages = [
    EmailPage,
    PaymentPage
  ]

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

  previousPage = () => {
    const { currentPageIndex } = this.state

    if (currentPageIndex > 0) {
      this.setState({
        currentPageIndex: currentPageIndex - 1
      })
    }
  }

  nextPage = () => {
    const { currentPageIndex } = this.state

    if (currentPageIndex < this.pages.length - 1) {
      this.setState({
        currentPageIndex: currentPageIndex + 1
      })
    }
  }

  render() {
    const { isAuthed } = this.props
    const { formData, currentPageIndex } = this.state
    const Page = this.pages[currentPageIndex]

    return (
      <div className='djn-checkoutModal container limit-screen w-2/3'>
        <form onSubmit={this.onSubmit}>
          <Page isAuthed={isAuthed} onChange={this.onChange} formData={formData} />

          {
            (currentPageIndex > 0) &&
            <Button type='none' text='Previous' onClick={this.previousPage}/>
          }

          {
            (currentPageIndex < this.pages.length - 1) &&
            <Button type='none' text='Next' onClick={this.nextPage}/>
          }


          {
            (currentPageIndex === this.pages.length - 1) &&
            <Button type='translucent' text='Purchase'/>
          }
        </form>
      </div>
    )
  }
}

export default injectStripe(CheckoutModal)
