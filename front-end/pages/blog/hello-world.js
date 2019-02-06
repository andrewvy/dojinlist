import React from 'react'

import Page from '../../layouts/main.js'
import withNavigation from '../../components/navigation'

import post from '../../posts/hello-world.js'
import BlogPostHeader from '../../components/blog_post_header'

const HelloWorldPage = (props) => {
  return (
    <Page>
      <title>dojinlist - {post.title}</title>
      <meta name='description' content={post.summary} />
      <meta name='twitter:card' content='summary' />
      <meta name='twitter:site' content='@dojinlist' />
      <meta name='twitter:title' content={`dojinlist - ${post.title}`} />
      <meta name='twitter:description' content={post.summary} />
      <meta property='og:title' content={`dojinlist - ${post.title}`} />
      <meta property='og:description' content={post.summary} />
      <meta property='og:url' content={`https://dojinlist.co/blog/${post.slug}`} />

      <div className='container limit-screen my-8 w-1/2'>
        <BlogPostHeader post={post}>
          <p>
            <a href='https://dojinlist.co'>dojinlist.co</a> is an international music marketplace and community for self-published creators. From the very start, we love these artists and wish to support them in every way possible.
          </p>
          <p>
            Since starting this project in November 2018, I've been hard at work building a quality service from the ground-up. This website provides an alternative experience
            to doujin music producers to share their works with the international audience. Addressing pain-points from artists + fans and creating an inclusive community is the
            main goal.
          </p>
          <p>Here is my long-term vision for this project:</p>
          <ol>
            <li>
              On day 1, create a sustainable music marketplace by starting with digital distribution.
            </li>
            <li>
              Create tools, harness people to create a great community and start delivering physical merchandise.
            </li>
            <li>
              Using profits, provide support to artists through curated publications and start a doujin label for collaboration projects.
            </li>
          </ol>
          <p>At all points, this will only work if we build a sustainable product that provides value for everyone.</p>
          <p>So, to start off with the launch, we will be setting a revenue cut of 6% + $0.30 USD. We also handle transaction fees. This will make it extremely simple for artists to calculate their portion of revenue. Artists are paid on a bi-weekly basis, via a traditional bank transfer that they are used to. Revenue will be purely used for covering operating costs, and any left-over potential profits will go back into growing the project.</p>
          <p>As we grow the platform, we will take on the responsibility of calculating sales tax, ensuring legal compliance necessary for selling music internationally on behalf of the artists. Eventually, we will provide additional services that an artist can leverage, including warehousing and order fulfillment for international customers.</p>
          <p>- vy</p>
        </BlogPostHeader>
      </div>
    </Page>
  )
}

export default withNavigation(HelloWorldPage)
