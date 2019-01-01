import Link from 'next/link'
import * as Yup from 'yup'
import { withRouter } from 'next/router'
import { Mutation } from 'react-apollo'

import { Formik, Field, ErrorMessage } from 'formik'

import Error from '../error'
import Button from '../button'
import LoginMutation from '../../mutations/login'

const LoginSchema = Yup.object().shape({
  email: Yup.string().required('An email is required'),
  password: Yup.string().required('A password is required'),
})

class Login extends React.Component {
  state = {
    afterSubmit: false,
    email: '',
    password: '',
    isLoading: false,
    error: null
  }

  setEmail = (e) => {
    this.setState({
      email: e.target.value
    })
  }

  setPassword = (e) => {
    this.setState({
      password: e.target.value
    })
  }

  initialValues = {
    email: '',
    password: ''
  }

  submit = (values) => {
    const { performLogin, login, router } = this.props
    const { email, password } = values

    this.setState({
      afterSubmit: true,
      isLoading: true
    })

    if (email.length && password.length) {
      performLogin({
        variables: {
          email,
          password,
        }
      }).then((response) => {
        if (response.data && response.data.login) {
          login(response.data.login.token)
          router.push('/')
        }
      }).catch((response) => {
        this.setState({
          error: 'Wrong email or password'
        })
      }).finally(() => {
        this.setState({
          isLoading: false
        })
      })
    } else {
      this.setState({
        isLoading: false
      })
    }
  }

  render() {
    const { email, password, isLoading, error } = this.state

    return (
      <>
        <div className='mt-32 form-container container xl:w-1/3 md:1/2 xs:w-5/6'>
          {
            error &&
            <Error>{error}</Error>
          }

          <div className='text-center font-extrabold'>
            <p>Sign in to Dojinlist</p>
          </div>

          <Formik
            initialValues={this.initialValues}
            validationSchema={LoginSchema}
            onSubmit={this.submit}
            render={({handleSubmit, touched, errors}) => (
              <form onSubmit={handleSubmit} className='form'>
                <fieldset className={`${Boolean(errors && errors.email && touched.email) ? 'has-error' : ''}`}>
                  <label htmlFor='email'>Email</label>
                  <ErrorMessage name='email' component={Error} />
                  <Field type='email' name='email' placeholder='Email' />
                </fieldset>

                <fieldset className={`${Boolean(errors && errors.password && touched.password) ? 'has-error' : ''}`}>
                  <label htmlFor='password'>Password</label>
                  <ErrorMessage name='password' component={Error} />
                  <Field type='password' name='password' placeholder='Password' />
                </fieldset>

                <div className='center'>
                  <Button isLoading={isLoading} >Login</Button>
                </div>
              </form>
            )}
          />

        </div>
        <div className='register container xl:w-1/3 md:1/2 xs:w-5/6 text-right my-4'>
          <Link href='/register'>
            Register an account
          </Link>
        </div>
      </>
    )
  }
}

const Wrapper = (props) => (
  <Mutation mutation={LoginMutation}>
    {(performLogin) => (
      <Login
        performLogin={performLogin}
        {...props}
      />
    )}
  </Mutation>
)

export default withRouter(Wrapper)
