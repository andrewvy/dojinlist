import gql from 'graphql-tag'

export default gql`
  mutation UploadAvatar(
    $avatar: Upload!,
    $storefrontId: ID!
  ) {
  uploadStorefrontAvatar(
    avatar: $avatar,
    storefrontId: $storefrontId
  ) {
    avatarImage
  }
}`
