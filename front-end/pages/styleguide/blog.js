import React from 'react';

import BlogTeaser from '../../components/blog_teaser';
import Page from '../../layouts/main.js';

import {
  Action,
  HeaderStyles,
  SubheaderStyles,
} from '../../lib/styleguideUtils.js';

const blog_post = {
  id: 'QmxvZ1Bvc3Q6Mw==',
  title: 'Hello World',
  slug: 'hello-world',
  cover_image:
    'https://s3.amazonaws.com/dojinlist-uploads/uploads/blog/hello-world.jpg',
  summary:
    "Hey, welcome to our little corner of the internet.\n\nI'm the sole founder, vy, and I'm here to tell you a little about our dojinlist.co project.\n\ndojinlist.co is a community site built around creating a place around the growing international audience of doujin music lovers. From the very start, we love these artists and wish to support them in every way possible.",
  date: 'November 20th, 2018',
  author: {
    username: 'andrewvy',
    avatar:
      'https://localhost:4001/uploads/avatars/thumb_cwxNqljjycIerYUk1rPj3.png',
  },
};

const BlogPage = props => {
  return (
    <Page>
      <div className="container limit-screen p-8">
        <h1 className={HeaderStyles}>Blog Teaser</h1>
        <div className="my-8">
          <div className={SubheaderStyles}>Primary</div>
          <BlogTeaser post={blog_post} />
        </div>
      </div>
    </Page>
  );
};

export default BlogPage;
