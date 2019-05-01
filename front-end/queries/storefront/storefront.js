import gql from 'graphql-tag'

export default gql`
query FetchStorefront($slug: String!) {
  storefront(slug: $slug) {
    id
    description
    displayName
    slug
    location
    bannerImage
    avatarImage
  }
}
`
