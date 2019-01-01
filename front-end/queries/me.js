import gql from 'graphql-tag'


export default gql`
query Me {
  me {
    username
    email
    avatar
  }
}
`
