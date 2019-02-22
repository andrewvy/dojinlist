import React from 'react'

import Page from '../../layouts/main.js'
import { Action, HeaderStyles, SubheaderStyles } from '../../lib/styleguideUtils.js'

import AlbumThumbnail from '../../components/album_thumbnail/'
import AlbumThumbnailGrid from '../../components/album_thumbnail_grid'
import AlbumTracklist from '../../components/album_tracklist'

const album = {
  artistName: 'Tycho',
  title: 'ボーナス・トラック',
  coverArtUrl: 'https://s3.amazonaws.com/dojinlist-uploads/uploads/original_HV8kNla_gg8YoSVvZbEV3.png',
  tracks: [
    {
      id: 1,
      title: 'Intro',
      playLength: 330
    },
    {
      id: 2,
      title: 'Bonus Track',
      playLength: 330
    },
  ]
}

const albums = [
  album,
  album,
  album,
  album,
  album,
  album,
  album,
  album,
  album,
  album,
  album,
  album
]

const ButtonPage = (props) => {
  return (
    <Page>
      <div className='container limit-screen p-8'>
        <h1 className={HeaderStyles}>Album</h1>
        <div className='my-8'>
          <div className={SubheaderStyles}>Album Thumbnail</div>

          <AlbumThumbnail
            album={album}
          />
        </div>
        <div className='my-8'>
          <div className={SubheaderStyles}>Album Thumbnail Grid</div>

          <AlbumThumbnailGrid
            albums={albums}
          />
        </div>
        <div className='my-8'>
          <div className={SubheaderStyles}>Album Tracklist</div>

          <AlbumTracklist
            album={album}
          />
        </div>
      </div>
    </Page>
  )
}

export default ButtonPage
