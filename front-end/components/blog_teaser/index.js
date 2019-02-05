import React from 'react'
import Link from 'next/link'

import './index.css'

const BlogTeaser = ({ post }) => (
  <div className='djn-blogTeaser'>
    <div className='title'>
      {post.title}
    </div>
    <div className='date'>
      September 23, 2019
    </div>
    <div className='summary'>
      {post.summary}
    </div>
    <div className='read-more'>
      <Link href={`/blog/${post.slug}`}>READ MORE →</Link>
    </div>
  </div>
)

export default BlogTeaser
