import gql from 'graphql-tag'

export default gql`
  mutation UpdateBlogPost(
    $id: ID!,
    $title: String!,
    $slug: String!,
    $content: String!,
    $summary: String
  ) {
  updateBlogPost(
    id: $id,
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
