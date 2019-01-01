import gql from 'graphql-tag'


export default gql`
query FetchAlbums {
  albums(first: 25) {
    edges {
      node {
        uuid
        name
        description
        releaseDate
        purchaseUrl
        coverArtUrl
        event {
          name
          startDate
          endDate
        }
        genres {
          name
        }
        artists {
          name
        }
        tracks {
          title
          kanaTitle
        }
      }
    }
  }
}
`
