import gql from 'graphql-tag'

export default gql`
{
  blogPosts(first:10) {
    edges {
      node {
        id
        title
        slug
        content
        insertedAt
        updatedAt
        author {
          username
          avatar
        }
      }
    }
  }
}
`
