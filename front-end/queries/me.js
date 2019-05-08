import gql from 'graphql-tag'


export default gql`
query Me {
  me {
    username
    email
    avatar
    storefront {
      id
      description
      displayName
      location
      bannerImage
      avatarImage
      albums {
        id
        uuid
        title
        price {
          amount
          currency
        }
        releaseDatetime
        coverArtUrl
        coverArtThumbUrl
        tracks {
          id
          title
          playLength
        }
      }
    }
    stripeAccount {
      stripeUserId
    }
  }
}`
