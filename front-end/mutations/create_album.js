import gql from 'graphql-tag'

export default gql`
  mutation CreateAlbum(
    $name: String!,
    $sampleUrl: String,
    $purchaseUrl: String,
    $artistIds: [Int],
    $genreIds: [Int],
    $coverArt: Upload
  ) {
  createAlbum(
    name: $name,
    sampleUrl: $sampleUrl,
    purchaseUrl: $purchaseUrl,
    artistIds: $artistIds,
    genreIds: $genreIds,
    coverArt: $coverArt
  ) {
    id
    uuid
    name
  }
}
`
