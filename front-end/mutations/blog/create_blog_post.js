import gql from 'graphql-tag'

export default gql`
  mutation CreateBlogPost(
    $title: String!,
    $slug: String!,
    $content: String!,
    $summary: String
  ) {
  createBlogPost(
    title: $title,
    slug: $slug,
    content: $content,
    summary: $summary
  ) {
    id
    title
    slug
    content
    summary
  }
}
`
