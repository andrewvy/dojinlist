import React, { Component } from 'react'

class AlbumCover extends Component {
  state = {
    active: false,
    angle: 0,
    tiltX: 0,
    tiltY: 0
  }

  onPointerEnter = (ev) => {
    this.setState({
      active: true,
    })
  }

  onPointerLeave = (ev) => {
    this.setState({
      active: false,
      angle: 0,
      tiltX: 0,
      tiltY: 0
    })
  }

  onPointerMove = (ev) => {
    const { active } = this.state

    if (active) {
      const { clientX, clientY, target } = ev
      const { height, width } = target
      const { left, top } = target.getBoundingClientRect()
      const [ midX, midY ] = [ 1 / 2, 1 / 2 ]
      const [ relativeX, relativeY ] = [ (clientX - left) / width, (clientY - top) / height ]

      const maxTilt = 2

      const tiltX = ((maxTilt / 2) - ((relativeX) * maxTilt)).toFixed(2)
      const tiltY = (((relativeY) * maxTilt) - (maxTilt / 2)).toFixed(2)

      const angle = Math.atan2(relativeX,- relativeY) * (180/Math.PI);

      this.setState({
        tiltX,
        tiltY,
        angle
      })
    }
  }

  render() {
    const { album } = this.props
    const { active, tiltX, tiltY} = this.state

//    const angleX = 20 * (tiltX)
//    const angleY = 20 * (tiltY * -1)

    const angleX = 45 * (tiltY * -1)
    const angleY = 45 * tiltX

    const transform = `perspective(300px) rotateX(${tiltY}deg) rotateY(${tiltX}deg)`

    const style = !active ? {
      transform: `rotate3d(0, 0, 0, 0deg)`,
      transition: '0.2s ease-in-out'
    } : {
      transform,
      transition: '0.1s ease-out'
    }

    return (
      <img src={album.coverArtUrl} className='djn-albumCover shadow rounded' onPointerEnter={this.onPointerEnter} onPointerLeave={this.onPointerLeave} onPointerMove={this.onPointerMove} style={style}/>
    )
  }
}

export default AlbumCover
