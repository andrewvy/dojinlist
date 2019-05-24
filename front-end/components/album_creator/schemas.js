import * as Yup from 'yup'

const TrackSchema = Yup.object().shape({
  title: Yup.string().required('Title is required'),
  position: Yup.number().required('Position is required'),
  sourceFile: Yup.mixed()
})

const AlbumSchema = Yup.object().shape({
  title: Yup.string()
    .min(2, 'Too short!')
    .required('Title is required'),

  slug: Yup.string()
    .min(2, 'Too short!')
    .required('Slug is required'),

  price: Yup.string()
    .matches(/[+-]?([0-9]*[.])?[0-9]+/, 'Should be a price'),

  coverArt: Yup.mixed()
})

export default {
  TrackSchema,
  AlbumSchema
}
