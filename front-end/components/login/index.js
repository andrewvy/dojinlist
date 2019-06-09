import React, { useReducer, useCallback } from 'react'
import Link from 'next/link'
import * as Yup from 'yup'
import { withRouter } from 'next/router'
import { Mutation } from 'react-apollo'
import { Formik, Field, ErrorMessage } from 'formik'

import { withNamespaces } from '../../lib/i18n'

import Error from '../error'
import Button from '../button'
import LoginMutation from '../../mutations/login'

import Logo from '../../svgs/brand/white_bg_fill_wordmark.svg'

const LoginSchema = Yup.object().shape({
  email: Yup.string().required('An email is required'),
  password: Yup.string().required('A password is required')
})

const LoginReducer = (state, action) => {
  switch (action.type) {
    case 'email':
      return { ...state, email: action.payload }
    case 'password':
      return { ...state, password: action.payload }
    case 'submit':
      return { ...state, afterSubmit: true, isLoading: true }
    case 'error':
      return { ...state, isLoading: false, error: action.payload }
    case 'success':
      return { ...state, isLoading: false }
    default:
      return state
  }
}

const Login = ({ performLogin, login, router, t }) => {
  const [state, dispatch] = useReducer(LoginReducer, {
    afterSubmit: false,
    isLoading: false,
    error: null
  })

  const { isLoading, error } = state

  const submit = useCallback(
    ({ email, password }) => {
      dispatch({ type: 'submit' })

      if (email.length && password.length) {
        performLogin({
          variables: {
            email,
            password
          }
        })
          .then(response => {
            if (response.data && response.data.login) {
              login(response.data.login.token)
              router.push('/')
            }
          })
          .catch(response => {
            dispatch({
              type: 'error',
              payload: 'Wrong email or password'
            })
          })
          .finally(() => {
            dispatch({ type: 'success' })
          })
      } else {
        dispatch({ type: 'success' })
      }
    },
    [performLogin, login, router]
  )

  return (
    <>
      <div className='mt-32 container' style={{ width: 500 }}>
        {error && <Error>{error}</Error>}

        <div className='w-1/3 m-auto my-8'>
          <Logo />
        </div>

        <Formik
          initialValues={{ email: '', password: '' }}
          validationSchema={LoginSchema}
          onSubmit={submit}
          render={({ handleSubmit, touched, errors }) => (
            <form onSubmit={handleSubmit} className='form'>
              <fieldset
                className={`${
                  Boolean(errors && errors.email && touched.email)
                    ? 'has-error'
                    : ''
                }`}
              >
                <label htmlFor='email'>{t('email-address')}</label>
                <ErrorMessage name='email' component={Error} />
                <Field
                  type='email'
                  name='email'
                  placeholder={t('email-address-placeholder')}
                />
              </fieldset>

              <fieldset
                className={`${
                  Boolean(errors && errors.password && touched.password)
                    ? 'has-error'
                    : ''
                }`}
              >
                <label htmlFor='password'>{t('password')}</label>
                <ErrorMessage name='password' component={Error} />
                <Field
                  type='password'
                  name='password'
                  placeholder={t('password-placeholder')}
                />
              </fieldset>

              <div className='center'>
                <Button
                  type='primary'
                  isLoading={isLoading}
                  className='w-full'
                  text={t('sign-in')}
                />
              </div>
            </form>
          )}
        />
      </div>
      <div className='register container text-center my-4'>
        <Link href='/register'>{t('not-a-member-btn')}</Link>
      </div>
    </>
  )
}

const Wrapper = withRouter(props => (
  <Mutation mutation={LoginMutation}>
    {performLogin => <Login performLogin={performLogin} {...props} />}
  </Mutation>
))

Wrapper.getInitialProps = async () => {
  return {
    namespaces: ['common']
  }
}

export default withNamespaces('common')(Wrapper)
