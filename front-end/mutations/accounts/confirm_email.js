import gql from 'graphql-tag'

export default gql`
  mutation ConfirmEmail(
    $token: String!,
  ) {
  confirmEmail(
    token: $token,
  ) {
    id
  }
}
`
