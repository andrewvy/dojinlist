import React, { useReducer, useCallback } from 'react'
import { withRouter } from 'next/router'
import Link from 'next/link'
import { Mutation } from 'react-apollo'
import { Formik, Field, ErrorMessage } from 'formik'
import * as Yup from 'yup'
import classnames from 'classnames'

import { withNamespaces } from '../../lib/i18n'

import Logo from '../../svgs/brand/white_bg_fill_wordmark.svg'

import RegisterMutation from '../../mutations/register'
import Button from '../button'
import Error from '../error'

import './index.css'

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
    .oneOf([Yup.ref('password')], "Passwords don't match")
    .required('Password confirmation is required'),

  agreeToTOS: Yup.bool()
    .test(
      'consent',
      'You must agree with our Terms and Conditions',
      value => value === true
    )
    .required('You must agree with our Terms and Conditions')
})

const initialValues = {
  username: '',
  email: '',
  password: '',
  passwordConfirmation: '',
  agreeToTOS: false
}

const RegisterReducer = (state, action) => {
  switch (action.type) {
    case 'submit':
      return { ...state, isLoading: true }
    case 'error':
      return {
        ...state,
        isLoading: false,
        success: false,
        errors: action.payload
      }
    case 'success':
      return { ...state, isLoading: false, success: true }
    default:
      return state
  }
}

const Register = ({ performRegister, router, t }) => {
  const [state, dispatch] = useReducer(RegisterReducer, {
    success: false,
    errors: null,
    isLoading: false
  })

  const { errors, success, isLoading } = state

  return (
    <div className='mt-24'>
      {success && (
        <div className='container success xl:w-1/3 md:1/2 xs:w-5/6 flex content-center items-center flex-col bg-green-light rounded text-white font-bold'>
          <p>{t('created-an-account')}</p>
          <Link href='/login'>
            <a className='text-white hover:text-blue-darker'>
              {t('sign-in-btn')}
            </a>
          </Link>
        </div>
      )}

      <div className='mt-32 container' style={{ width: 500 }}>
        <div className='w-1/3 m-auto my-8'>
          <Logo />
        </div>

        <Formik
          initialValues={initialValues}
          validationSchema={RegisterSchema}
          onSubmit={(values, actions) => {
            const variables = {
              username: values.username,
              email: values.email,
              password: values.password
            }

            dispatch({ type: 'submit' })

            performRegister({ variables }).then(
              response => {
                dispatch({ type: 'success' })
              },
              error => {
                const formattedErrors = error.graphQLErrors
                  .map(error => error.message)
                  .join('\n')

                dispatch({ type: 'error', payload: formattedErrors })
              }
            )
          }}
          render={props => (
            <form onSubmit={props.handleSubmit} className='form'>
              {errors && <Error>{errors}</Error>}

              <fieldset
                className={classnames({
                  'has-error': Boolean(
                    props.errors &&
                      props.errors.username &&
                      props.touched.username
                  )
                })}
              >
                <label htmlFor='username'>{t('username')}</label>
                <ErrorMessage name='username' component={Error} />
                <Field
                  type='text'
                  name='username'
                  placeholder={t('username-placeholder')}
                />
              </fieldset>

              <fieldset
                className={classnames({
                  'has-error': Boolean(
                    props.errors && props.errors.email && props.touched.email
                  )
                })}
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
                className={classnames({
                  'has-error': Boolean(
                    props.errors &&
                      props.errors.password &&
                      props.touched.password
                  )
                })}
              >
                <label htmlFor='password'>{t('password')}</label>
                <ErrorMessage name='password' component={Error} />
                <Field
                  type='password'
                  name='password'
                  placeholder={t('password-placeholder')}
                />
              </fieldset>

              <fieldset
                className={classnames({
                  'has-error': Boolean(
                    props.errors &&
                      props.errors.passwordConfirmation &&
                      props.touched.passwordConfirmation
                  )
                })}
              >
                <label htmlFor='passwordConfirmation'>
                  {t('confirm-password')}
                </label>
                <ErrorMessage name='passwordConfirmation' component={Error} />
                <Field
                  type='password'
                  name='passwordConfirmation'
                  placeholder={t('confirm-password-placeholder')}
                />
              </fieldset>

              <fieldset
                className={classnames({
                  'has-error': Boolean(
                    props.errors &&
                      props.errors.agreeToTOS &&
                      props.touched.agreeToTOS
                  )
                })}
              >
                <ErrorMessage name='agreeToTOS' component={Error} />
                <label htmlFor='agreeToTOS' className='inline-block'>
                  <a href='/terms' target='_blank'>
                    {t('agree-to-terms-of-service')}
                  </a>
                </label>
                <Field
                  type='checkbox'
                  name='agreeToTOS'
                  className='ml-3 inline-block'
                />
              </fieldset>

              <Button
                type='primary'
                isLoading={isLoading}
                className='w-full'
                text={t('sign-up')}
              />
            </form>
          )}
        />
      </div>
      <div className='login container text-center my-4'>
        <Link href='/login'>{t('already-a-member-btn')}</Link>
      </div>
    </div>
  )
}

const Wrapper = withRouter(props => (
  <Mutation mutation={RegisterMutation} errorPolicy='all'>
    {performRegister => (
      <Register performRegister={performRegister} {...props} />
    )}
  </Mutation>
))

Wrapper.getInitialProps = async () => {
  return {
    namespaces: ['common']
  }
}

export default withNamespaces('common')(Wrapper)
