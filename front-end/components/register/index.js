import { withRouter } from 'next/router'
import Link from 'next/link'
import { Mutation } from 'react-apollo'
import { Formik, Field, ErrorMessage } from 'formik'
import * as Yup from 'yup'

import RegisterMutation from '../../mutations/register'
import Button from '../button'
import Error from '../error'

const RegisterSchema = Yup.object().shape({
  username: Yup.string()
    .min(2, 'Too short!')
    .max(70, 'Too long!')
    .matches(/^\S*$/, 'Should not contain spaces')
    .required('Username is required'),

  email: Yup.string()
    .email('Invalid email')
    .required('Email is required'),

  password: Yup.string()
    .min(5, 'Too short!')
    .required('Password is required'),

  passwordConfirmation: Yup.string()
    .oneOf([Yup.ref('password')], 'Passwords don\'t match')
    .required('Password confirmation is required'),

  agreeToTOS: Yup.bool()
      .test(
        'consent',
        'You must agree with our Terms and Conditions',
        value => value === true
      )
      .required(
        'You must agree with our Terms and Conditions'
      ),
})

import './index.css'

class Register extends React.Component {
  initialValues = {
    username: '',
    email: '',
    password: '',
    passwordConfirmation: '',
    agreeToTOS: false
  }

  state = {
    success: false,
    errors: null,
    isLoading: false
  }

  render() {
    const { errors, success, isLoading } = this.state
    const { performRegister, router } = this.props

    return (
      <div className='mt-24'>
        {
          success &&
          <div className='container success xl:w-1/3 md:1/2 xs:w-5/6 flex content-center items-center flex-col bg-green-light rounded text-white font-bold'>
            <p>Successfully created an account.</p>
            <Link href='/login'><a className='text-white hover:text-blue-darker'>Click here to login.</a></Link>
          </div>
        }

        <div className='container form-container xl:w-1/3 md:1/2 xs:w-5/6'>
          <div className='text-center font-extrabold'>
            <p>Sign up to Dojinlist</p>
          </div>

          <Formik
            initialValues={this.initialValues}
            validationSchema={RegisterSchema}
            onSubmit={(values, actions) => {
              const variables = {
                username: values.username,
                email: values.email,
                password: values.password,
              }

              this.setState({
                isLoading: true
              })

              performRegister({variables}).then((response) => {
                this.setState({
                  success: true,
                  isLoading: false
                })
              }, (error) => {
                const formattedErrors = error.graphQLErrors.map((error) => error.message).join('\n')

                this.setState({
                  errors: formattedErrors,
                  isLoading: false
                })
              })
            }}
            render={props => (
              <form onSubmit={props.handleSubmit} className='form'>
                {
                  errors &&
                  <Error>{errors}</Error>
                }

                <fieldset className={`${Boolean(props.errors && props.errors.username && props.touched.username) ? 'has-error' : ''}`}>
                  <label htmlFor='username'>Username</label>
                  <ErrorMessage name='username' component={Error} />
                  <Field type='text' name='username' placeholder='Username'/>
                </fieldset>

                <fieldset className={`${Boolean(props.errors && props.errors.email && props.touched.email) ? 'has-error' : ''}`}>
                  <label htmlFor='email'>Email</label>
                  <ErrorMessage name='email' component={Error} />
                  <Field type='email' name='email' placeholder='Email'/>
                </fieldset>

                <fieldset className={`${Boolean(props.errors && props.errors.password && props.touched.password) ? 'has-error' : ''}`}>
                  <label htmlFor='password'>Password</label>
                  <ErrorMessage name='password' component={Error} />
                  <Field type='password' name='password' placeholder='Password'/>
                </fieldset>

                <fieldset className={`${Boolean(props.errors && props.errors.passwordConfirmation && props.touched.passwordConfirmation) ? 'has-error' : ''}`}>
                  <label htmlFor='passwordConfirmation'>Confirm Password</label>
                  <ErrorMessage name='passwordConfirmation' component={Error} />
                  <Field type='password' name='passwordConfirmation' placeholder='Password Confirmation'/>
                </fieldset>

                <fieldset className={`${Boolean(props.errors && props.errors.agreeToTOS && props.touched.agreeToTOS) ? 'has-error' : ''}`}>
                  <ErrorMessage name='agreeToTOS' component={Error} />
                  <label htmlFor='agreeToTOS' className='inline-block'>Do you agree to our <a href='/terms' target='_blank'>Terms of Service?</a></label>
                  <Field type='checkbox' name='agreeToTOS' className='ml-3 inline-block'/>
                </fieldset>

                <Button type='primary' isLoading={isLoading} text='Register' />
              </form>
            )}
          />
        </div>
        <div className='login container xl:w-1/3 md:1/2 xs:w-5/6 text-right my-4'>
          <Link href='/login'>
            Already have an account? Log In
          </Link>
        </div>
      </div>
    )
  }
}

const Wrapper = (props) => (
  <Mutation mutation={RegisterMutation} errorPolicy='all'>
    {(performRegister) => (
      <Register
        performRegister={performRegister}
        {...props}
      />
    )}
  </Mutation>
)

export default withRouter(Wrapper)
