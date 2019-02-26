const EmailPage = ({ isAuthed, onChange, formData }) => (
  <div className='djn-checkoutPage'>
    Email Page

    {
      isAuthed ?
        <div>Your purchase will be associated with your account.</div>
      :
        <fieldset>
          <label htmlFor='email'>Email Address</label>
          <input type='email' placeholder='Email' required onChange={onChange('email')} value={formData.email} />
        </fieldset>
    }
  </div>
)

export default EmailPage
