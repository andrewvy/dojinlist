import React, { PureComponent } from 'react'

import RangeControlOverlay from './rangeControlOverlay.js'

const noop = () => {}

/**
 * Slider
 *
 * A wrapper around <RangeControlOverlay /> that may be used to
 * compose slider controls such as volume sliders or progress bars.
 */
class Slider extends PureComponent {
  static defaultProps = {
    direction: 'HORIZONTAL',
    isEnabled: true,
    onIntent: noop,
    onIntentStart: noop,
    onIntentEnd: noop,
    onChange: noop,
    onChangeStart: noop,
    onChangeEnd: noop,
    children: null,
    className: null,
    style: {},
    overlayZIndex: 10,
  }

  $el = null

  storeRef ($el) {
    this.$el = $el
  }

  handleIntent (intent) {
    if (this.props.isEnabled) {
      this.props.onIntent(intent)
    }
  }

  handleIntentStart (intent) {
    if (this.props.isEnabled) {
      this.props.onIntentStart(intent)
    }
  }

  handleIntentEnd () {
    if (this.props.isEnabled) {
      this.props.onIntentEnd()
    }
  }

  handleChange (value) {
    if (this.props.isEnabled) {
      this.props.onChange(value)
    }
  }

  handleChangeStart (value) {
    if (this.props.isEnabled) {
      this.props.onChangeStart(value)
    }
  }

  handleChangeEnd (value) {
    if (this.props.isEnabled) {
      this.props.onChangeEnd(value)
    }
  }

  render () {
    const {
      direction,
      children,
      className,
      style,
      overlayZIndex,
    } = this.props

    return (
      <div
        ref={this.storeRef.bind(this)}
        className={className}
        style={{
          position: 'relative',
          ...style,
        }}
      >
        {children}

        {/*
          TODO: Make it possible to render or extend this node yourself,
          so that these styles – the z-index property in particular – is
          not forced upon the component consumer.
        */}
        <RangeControlOverlay
          direction={direction}
          bounds={() => this.$el.getBoundingClientRect()}
          onIntent={this.handleIntent.bind(this)}
          onIntentStart={this.handleIntentStart.bind(this)}
          onIntentEnd={this.handleIntentEnd.bind(this)}
          onChange={this.handleChange.bind(this)}
          onChangeStart={this.handleChangeStart.bind(this)}
          onChangeEnd={this.handleChangeEnd.bind(this)}
          style={{
            position: 'absolute',
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            zIndex: overlayZIndex,
          }}
        />
      </div>
    )
  }
}

export default Slider
