import gql from 'graphql-tag'

export default gql`
  mutation UploadAvatar(
    $avatar: Upload!
  ) {
  uploadAvatar(
    avatar: $avatar
  ) {
    username
    email
    avatar
  }
}
`
