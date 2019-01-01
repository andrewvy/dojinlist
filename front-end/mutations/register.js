import gql from 'graphql-tag'

export default gql`
  mutation Register($username: String!, $email: String!, $password: String!) {
    register(username: $username, email: $email, password: $password) {
      user {
        username
        email
        id
      }
    }
  }
`
