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
  content:
    "Hey, welcome to our little corner of the internet.\n\nI'm the sole founder, vy, and I'm here to tell you a little about our dojinlist.co project.\n\n[dojinlist.co](https://dojinlist.co) is a community site built around creating a place around the growing international audience of doujin music lovers. From the very start, we love these artists and wish to support them in every way possible.\n\nDojinlist is founded on a few principles:\n\n- **Support multiple languages.** The site should be built to support easy localization to other languages for the international audience.\n- **Search must be fast and accessible.** We built the site around discovering all your artists, and albums as quick as possible. Search albums by events, by circles, by genres, by tracklist. It's all there.\n- **Discover new artists.** We want to highlight all types of circles. We've found it hard to get new recommendations, most of which we've shared naturally through friends. Using our data, we want to implement the best recommendation algorithm for doujin music, and its variety of genres/influences.\n- **Support artists.** We want to make it easy to find how to buy albums, either physically or digitally. In the very far future, we want to collaborate with artists to help them reach the international audience much easier.\n\nThings are being worked on at a rapid pace for our first release in 2019! To get notified about potential alpha participation, follow us at [@dojinlist](https://twitter.com/dojinlist) on Twitter. :)",
  summary: "Hey, welcome to our little corner of the internet.\n\nI'm the sole founder, vy, and I'm here to tell you a little about our dojinlist.co project.\n\ndojinlist.co is a community site built around creating a place around the growing international audience of doujin music lovers. From the very start, we love these artists and wish to support them in every way possible.",
  insertedAt: '2018-11-20T00:03:40Z',
  updatedAt: '2018-11-20T04:28:17Z',
  author: {
    username: 'andrewvy',
    avatar:
      'https://localhost:4001/uploads/avatars/thumb_cwxNqljjycIerYUk1rPj3.png',
    __typename: 'User',
  },
  __typename: 'BlogPost',
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
