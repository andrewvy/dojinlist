import ReactMarkdown from 'react-markdown'
import { withRouter } from 'next/router'
import Link from 'next/link'

import Button from '../../components/button'
import onlyAuthenticated from '../../lib/onlyAuthenticated'
import Page from '../../layouts/main.js'
import Error from '../../components/error'

import { Mutation } from 'react-apollo'

import CreateBlogPostMutation from '../../mutations/blog/create_blog_post.js'

const slugify = (title) => (
  title.toLowerCase().replace(/\W+/g, '-')
)

class NewBlogPost extends React.Component {
  state = {
    content: '',
    slug: '',
    title: '',
    summary: '',
    successUrl: false,
    error: null
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
    const { createBlogPost } = this.props
    const { content, title, slug, summary } = this.state

    const variables = {
      content,
      title,
      slug,
      summary
    }

    createBlogPost({variables}).then((response) => {
      this.setState({
        successUrl: `/blog/${slug}`
      })
    }).catch((error) => {
      this.setState({
        error: "Could not create blog post. Check slug?"
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

const Wrapper = (props) => (
  <Mutation mutation={CreateBlogPostMutation}>
    {(createBlogPost) => (
      <NewBlogPost
        {...props}
        createBlogPost={createBlogPost}
      />
    )}
  </Mutation>
)

export default onlyAuthenticated(
  withRouter(
    Wrapper
  )
)
