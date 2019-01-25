import React from 'react'
import { withRouter } from 'next/router'
import { Query } from 'react-apollo'
import Head from 'next/head'

import Page from '../layouts/main.js'
import Spinner from '../components/spinner'
import FetchBlogPostBySlugQuery from '../queries/fetch_blog_post_by_slug.js'
import BlogPost from '../components/blog_post'
import withNavigation from '../components/navigation'

class Blog extends React.Component {
  render() {
    const { router } = this.props
    const { query } = router
    const { slug } = query

    return (
      <Query query={FetchBlogPostBySlugQuery} variables={{slug}}>
        {({loading, data}) => {
          if (loading) {
            return (
              <Page>
                <div className='container vertical-center'>
                  <Spinner color='blue-darker' />
                </div>
              </Page>
            )
          } else if (data) {
            return (
              <Page>
                <Head>
                  <title>dojinlist - {data.blogPost.title}</title>
                  <meta name='description' content={data.blogPost.summary} />
                  <meta name='twitter:card' content='summary' />
                  <meta name='twitter:site' content='@dojinlist' />
                  <meta name='twitter:title' content={`dojinlist - ${data.blogPost.title}`} />
                  <meta name='twitter:description' content={data.blogPost.summary} />
                  <meta property='og:title' content={`dojinlist - ${data.blogPost.title}`} />
                  <meta property='og:description' content={data.blogPost.summary} />
                  <meta property='og:url' content={`https://dojinlist.co/blog/${data.blogPost.slug}`} />
                </Head>
                <BlogPost post={data.blogPost} />
              </Page>
            )
          } else {
            return (
              <Page>
                <div className='container vertical-center'>404: Could not find blog post.</div>
              </Page>
            )
          }
        }}
      </Query>
    )
  }
}

export default withRouter(withNavigation(Blog))
