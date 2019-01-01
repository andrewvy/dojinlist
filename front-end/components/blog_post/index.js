import Link from 'next/link'

import dateFormat from 'date-fns/format'
import dateParse from 'date-fns/parse'
import ReactMarkdown from 'react-markdown'

import Avatar from '../avatar'

import './index.css'

const displayDate = (date) => {
  const parsedDate = dateParse(date)

  return dateFormat(parsedDate, "MMMM Do YYYY")
}

const BlogPost = (props) => (
  <div className='container w-1/2'>
    <Link href={`/blog/${props.post.slug}`}>
      <h1 className='blog-title'>
        <a>
          {props.post.title}
        </a>
      </h1>
    </Link>
    <div className='blog-header inline-flex'>
      <Avatar user={props.post.author} />
      <div>{props.post.author.username}</div>
    </div>
    <div className='date'>{displayDate(props.post.insertedAt)}</div>
    <ReactMarkdown source={props.post.content} className='blog-content' />
  </div>
)

export default BlogPost
