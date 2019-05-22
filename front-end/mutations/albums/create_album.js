import gql from 'graphql-tag'

export default gql`
  mutation CreateAlbum(
    $album: AlbumInput!
  ) {
    createAlbum(
      album: $album
    ) {
      album {
        id
      }
      errors {
        errorCode
        errorMessage
      }
    }
  }
`
