import gql from 'graphql-tag'

export default gql`
query FetchAlbumsByStorefrontId($storefrontId: ID!, $first: Int!) {
  albums(storefrontId: $storefrontId, first: $first) {
    edges {
      node {
        id
        uuid
        title
        description
        slug
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
  }
}
`
