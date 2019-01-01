import React from 'react'
import Link from 'next/link'
import { Query } from 'react-apollo'

import { AuthConsumer } from '../contexts/auth.js'
import Spinner from '../components/spinner'
import FetchBlogPostsQuery from '../queries/blog_posts.js'
import BlogPost from '../components/blog_post'

import Page from '../layouts/main.js'

const Styles = () => (
  <style jsx='true'>
  {`
    body {
      margin: 0;
      text-align: center;
    }
    .navigation {
      padding-top: 20px;
      animation: 0.5s ease-out 0s 1 slideIn;
    }
    @keyframes slideIn {
      0% {
        opacity: 0;
        transform: translateY(-20px);
      }
      100% {
        opacity: 1;
        transform: translateY(0px);
      }
    }
    .logo {
      font-size: 18pt;
      font-weight: 300;
      color: hsl(207.3, 9.3%, 50%);
    }
    .logo span {
      color: hsl(0, 100%, 60%);
    }
    .content {
      animation: 0.5s ease-out 0s 1 slideIn;
      padding-top: 20px;
    }
    .content em {
      user-select: none;
    }
    .hover {
      cursor: pointer;
      text-decoration: underline;
    }
    .bongo {
      width: 200px;
      animation: 0.5s ease-out 0s infinite bongo;
      border-radius: 5px;
    }
    @keyframes bongo {
      0% {
        transform: translateY(-20px);
      }
      50% {
        transform: translateY(0px);
      }
      100% {
        transform: translateY(-20px);
      }
    }

    .blog-posts {
      text-align: left;
    }
  `}
  </style>
)

class IndexPage extends React.Component {
  render() {

    return (
      <Query query={FetchBlogPostsQuery}>
        {({data}) => (
          <Page>
            <nav className='navigation'>
              <section className='container'>
                <p className='logo'>dojin<span>list</span></p>
              </section>
            </nav>
            <div className='container content'>
              <p>
                <em>early 2019 - vy</em>
              </p>
              <div className='blog-posts'>
                {
                  data &&
                  data.blogPosts &&
                  data.blogPosts.edges.map((post) => (
                    <BlogPost key={post.node.id} post={post.node} />
                  ))
                }
              </div>
              <AuthConsumer>
              {({isAuthed}) => {
                if (isAuthed) {
                  return (
                    <p>
                      <span>Logged in? </span>
                      <Link href='/profile'>
                        <a>Go to your profile.</a>
                      </Link>
                    </p>
                  )
                } else {
                  return ''
                }
              }}
              </AuthConsumer>
            </div>
            <Styles />
          </Page>
        )}
      </Query>
    )
  }
}

export default IndexPage
