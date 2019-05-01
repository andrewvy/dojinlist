import gql from 'graphql-tag'

export default gql`
  mutation UploadBanner(
    $banner: Upload!,
    $storefrontId: ID!
  ) {
  uploadStorefrontBanner(
    banner: $banner,
    storefrontId: $storefrontId
  ) {
    bannerImage
  }
}`
