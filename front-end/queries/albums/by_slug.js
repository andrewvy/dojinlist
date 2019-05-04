import gql from 'graphql-tag'

export default gql`
query FetchAlbumBySlug($slug: String!) {
  album(slug: $slug) {
    id
    uuid
    title
    releaseDatetime
    coverArtUrl
    coverArtThumbUrl
    tracks {
      id
      title
      playLength
    }
    storefront {
      displayName
      slug
      location
      bannerImage
      avatarImage
    }
  }
}
`
