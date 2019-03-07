import gql from 'graphql-tag'

export default gql`
  mutation CheckoutAlbum(
    $albumId: ID!,
    $token: String!,
    $userEmail: String
  ) {
    checkoutAlbum(
      albumId: $albumId,
      token: $token,
      userEmail: $userEmail
    ) {
      transactionId
      errors {
        errorCode
        errorMessage
      }
    }
  }
`
