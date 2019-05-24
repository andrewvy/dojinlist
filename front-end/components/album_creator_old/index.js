import React from 'react'
import * as Yup from 'yup'
import { Mutation } from 'react-apollo'
import { Formik, Field, ErrorMessage } from 'formik'

import CreateAlbumMutation from '../../mutations/create_album'
import Error from '../error'

const AlbumSchema = Yup.object().shape({
  name: Yup.string()
    .min(2, 'Too short!')
    .required('Name is required'),

  sampleUrl: Yup.string(),
  purchaseUrl: Yup.string(),
  artistIds: Yup.array(Yup.string()),
  genreIds: Yup.array(Yup.string()),
  coverArt: Yup.mixed()
})

class AlbumCreator extends React.Component {
  state = {
    success: false,
    errors: null
  }

  initialValues = {
    name: '',
    sampleUrl: '',
    purchaseUrl: '',
    artistIds: [],
    genreIds: [],
    coverArt: null
  }

  render() {
    const { errors, success } = this.state
    const { performCreateAlbum } = this.props

    return (
      <div className='container vertical-center'>
        {
          success &&
          <div className='success'>
            Submitted a new album for review.
          </div>
        }

        <Formik
          initialValues={this.initialValues}
          validationSchema={AlbumSchema}
          onSubmit={(values, actions) => {
            const variables = {
              name: values.name,
              sampleUrl: values.sampleUrl,
              purchaseUrl: values.purchaseUrl,
              artistIds: values.artistIds,
              genreIds: values.genreIds,
              coverArt: values.coverArt
            }

            performCreateAlbum({variables}).then((response) => {
              this.setState({
                success: true
              })
            }, (error) => {
              const formattedErrors = error.graphQLErrors.map((error) => error.message).join('\n')

              this.setState({
                errors: formattedErrors
              })
            })
          }}
          render={({handleSubmit, setFieldValue}) => (
            <form onSubmit={handleSubmit}>
              {
                errors &&
                <Error>{errors}</Error>
              }

              <fieldset>
                <label htmlFor='name'>Album Name</label>
                <ErrorMessage name='name' component={Error} />
                <Field type='text' name='name' placeholder='Album Name' />
              </fieldset>

              <fieldset>
                <label htmlFor='sampleUrl'>Sample URL</label>
                <ErrorMessage name='sampleUrl' component={Error} />
                <Field type='text' name='sampleUrl' placeholder='Sample URL' />
              </fieldset>

              <fieldset>
                <label htmlFor='purchaseUrl'>Purchase URL</label>
                <ErrorMessage name='purchaseUrl' component={Error} />
                <Field type='text' name='purchaseUrl' placeholder='Purchase URL' />
              </fieldset>

              <fieldset>
                <label htmlFor='coverArt'>Album Cover Art</label>
                <input
                  id='file'
                  name='coverArt'
                  type='file'
                  onChange={(event) => {
                    setFieldValue('coverArt', event.currentTarget.files[0]);
                  }}
                />
              </fieldset>

              <button className='button button-primary' type='submit'>Submit Album</button>
            </form>
          )}
        />
      </div>
    )
  }
}

const Wrapper = (props) => (
  <Mutation mutation={CreateAlbumMutation} errorPolicy='all'>
    {(performCreateAlbum) => (
      <AlbumCreator
        performCreateAlbum={performCreateAlbum}
        {...props}
      />
    )}
  </Mutation>
)

export default Wrapper
