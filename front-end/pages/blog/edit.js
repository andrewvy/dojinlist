import ReactMarkdown from 'react-markdown'
import { withRouter } from 'next/router'
import Link from 'next/link'
import { Query, Mutation } from 'react-apollo'

import Button from '../../components/button'
import onlyAuthenticated from '../../lib/onlyAuthenticated'
import Page from '../../layouts/main.js'
import Error from '../../components/error'

import FetchBlogPostBySlugQuery from '../../queries/fetch_blog_post_by_slug.js'
import UpdateBlogPostMutation from '../../mutations/blog/update_blog_post.js'

const slugify = (title) => (
  title.toLowerCase().replace(/\W+/g, '-')
)

class EditBlogPost extends React.Component {
  state = {
    content: '',
    slug: '',
    title: '',
    summary: '',
    successUrl: false,
    error: null
  }

  constructor(props) {
    super(props)

    const { post } = this.props

    this.state.content = post.content
    this.state.slug = post.slug
    this.state.title = post.title
  }

  setContent = (e) => {
    this.setState({
      content: e.target.value
    })
  }

  setTitle = (e) => {
    this.setState({
      title: e.target.value,
    })
  }

  setSlug = (e) => {
    this.setState({
      slug: slugify(e.target.value)
    })
  }

  setSummary = (e) => {
    this.setState({
      summary: e.target.value
    })
  }

  submit = () => {
    const { updateBlogPost, post } = this.props
    const { content, title, slug, summary } = this.state

    const variables = {
      id: post.id,
      content,
      title,
      slug,
      summary
    }

    updateBlogPost({variables}).then((response) => {
      this.setState({
        successUrl: `/blog/${slug}`
      })
    }).catch((error) => {
      this.setState({
        error: "Could not update blog post."
      })
    })
  }

  render() {
    const { content, title, slug, summary, successUrl, error } = this.state

    return (
      <Page>
        <div className='wrapper'>
          <div className='column'>
            {
              error &&
              <Error>{error}</Error>
            }

            {
              successUrl &&
              <Link href={successUrl}><a>Created the blog post!</a></Link>
            }

            <input type='text' value={title} onChange={this.setTitle} placeholder='Name'/>
            <input type='text' value={slug} onChange={this.setSlug} placeholder='Slug'/>
            <textarea className='blog-summary' value={summary} onChange={this.setSummary} placeholder='Summary'/>
            <textarea className='blog-content' value={content} onChange={this.setContent} placeholder='Content'/>
            <Button onClick={this.submit}>Submit</Button>
          </div>
          <div className='column'>
            <ReactMarkdown source={content} />
          </div>
        </div>
        <style jsx>{`
          .wrapper {
            display: flex;
            flex-wrap: wrap;
            padding-top: 32px;
          }

          .blog-content {
            width: 100%;
          }

          .column {
            width: 50%;
            padding-left: 16px;
            box-sizing: border-box;
          }
        `}</style>
      </Page>
    )
  }
}

const Wrapper = (props) => {
  const { router } = props
  const { query } = router
  const { slug } = query

  return (
    <Query query={FetchBlogPostBySlugQuery} variables={{slug}}>
      {({data}) => {
        if (data) {
          return (
            <Mutation mutation={UpdateBlogPostMutation}>
              {(updateBlogPost) => (
                <EditBlogPost
                  {...props}
                  updateBlogPost={updateBlogPost}
                  post={data.blogPost}
                />
              )}
            </Mutation>
          )
        } else {
          return (
            <div>Loading</div>
          )
        }
      }}
    </Query>
  )
}

export default onlyAuthenticated(
  withRouter(
    Wrapper
  )
)
