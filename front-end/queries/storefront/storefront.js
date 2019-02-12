import gql from 'graphql-tag'

export default gql`
query FetchStorefront($subdomain: String!) {
  storefront(subdomain: $subdomain) {
    id
    description
    display_name
    subdomain
    location
  }
}
`
