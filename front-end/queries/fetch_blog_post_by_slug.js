import gql from 'graphql-tag'

export default gql`
query FetchBlogPostBySlug($slug: String!) {
  blogPost(slug: $slug) {
    id
    title
    slug
    content
    summary
    insertedAt
    updatedAt
    author {
      username
      avatar
    }
  }
}
`
