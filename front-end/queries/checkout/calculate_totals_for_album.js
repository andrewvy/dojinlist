import gql from 'graphql-tag'

export default gql`
  query CalculateTotalsForAlbum(
    $albumId: ID!,
    $country: String,
    $state: String
    $postalCode: String
  ) {
    calculateTotalsForAlbum(
      albumId: $albumId,
      country: $country,
      state: $state,
      postalCode: $postalCode
    ) {
      cartTotals {
        subTotal {
          amount
          currency
        }
        taxTotal {
          amount
          currency
        }
        shippingTotal {
          amount
          currency
        }
        grandTotal {
          amount
          currency
        }
      }
      errors {
        errorCode
        errorMessage
      }
    }
  }
`
