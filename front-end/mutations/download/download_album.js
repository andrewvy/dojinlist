import gql from 'graphql-tag'

export default gql`
  mutation DownloadAlbum(
    $download: DownloadAlbumInput!
  ) {
    generateAlbumDownloadUrl(
      download: $download
    ) {
      url
      errors {
        errorCode
        errorMessage
      }
    }
  }
`
