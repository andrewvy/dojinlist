import gql from 'graphql-tag'

export default gql`
query FetchStorefront($slug: String!) {
  storefront(slug: $slug) {
    id
    description
    display_name
    slug
    location
    bannerImage
    avatarImage
  }
}
`
