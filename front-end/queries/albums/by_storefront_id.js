import gql from 'graphql-tag'

export default gql`
query FetchAlbumsByStorefrontId($storefrontId: ID!, $first: Int!) {
  albums(storefrontId: $storefrontId, first: $first) {
    edges {
      node {
        uuid
        title
        slug
        releaseDatetime
        coverArtUrl
        coverArtThumbUrl
        tracks {
          title
          playLength
        }
      }
    }
  }
}
`
