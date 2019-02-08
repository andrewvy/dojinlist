import gql from 'graphql-tag'

export default gql`
query FetchStorefront($subdomain: String!) {
  storefront(subdomain: $subdomain) {
    description
    display_name
    subdomain
    location
  }
}
`
