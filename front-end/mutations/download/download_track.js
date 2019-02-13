import gql from 'graphql-tag'

export default gql`
  mutation DownloadTrack(
    $download: DownloadTrackInput!
  ) {
    generateTrackDownloadUrl(
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
