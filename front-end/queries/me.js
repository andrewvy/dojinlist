import gql from 'graphql-tag'


export default gql`
query Me {
  me {
    username
    email
    avatar
    storefronts {
      id
      description
      displayName
      location
      slug
      bannerImage
      avatarImage
    }
    stripeAccount {
      stripeUserId
    }
  }
}`
