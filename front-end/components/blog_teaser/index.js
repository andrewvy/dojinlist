import React from 'react'
import Link from 'next/link'

import './index.css'

const BlogTeaser = ({ post }) => (
  <div className='djn-blogTeaser'>
    <div className='left'>
      <img src={post.cover_image} className='cover-image'/>
    </div>
    <div className='right'>
      <div className='title'>
        {post.title}
      </div>
      <div className='date'>
        {post.date}
      </div>
      <div className='summary'>
        <p>
          {post.summary}
        </p>
      </div>
      <div className='read-more'>
        <Link href={`/blog/${post.slug}`}>READ MORE →</Link>
      </div>
    </div>
  </div>
)

export default BlogTeaser
