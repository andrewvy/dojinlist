import Link from 'next/link'

import dateFormat from 'date-fns/format'
import dateParse from 'date-fns/parse'
import ReactMarkdown from 'react-markdown'

import Avatar from '../avatar'

import './index.css'

const BlogPostHeader = (props) => (
  <div className='djn-blogPostHeader w-7/8'>
    <img src={props.post.cover_image} className='cover-image' />

    <h1 className='blog-title'>
      {props.post.title}
    </h1>

    <div className='blog-content'>
      {props.children}
    </div>
  </div>
)

export default BlogPostHeader
