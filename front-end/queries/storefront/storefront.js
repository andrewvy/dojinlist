import gql from 'graphql-tag'

export default gql`
query FetchStorefront($username: String!) {
  storefront(username: $username) {
    id
    description
    displayName
    location
    bannerImage
    avatarImage
  }
}
`
