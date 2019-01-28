import React from 'react'

import Slider from './slider'

const GRAY = '#878c88'

const SliderHandleStyles = <style jsx='true'>{`
  .djn-sliderHandle {
    position: absolute;
    width: 16px;
    height: 16px;
    border-radius: 100%;
    transition: transform 0.2s;
  }

  .djn-sliderHandle.horizontal {
    top: 0;
    margin-top: -4px;
    margin-left: -8px;
  }

  .djn-sliderHandle.vertical {
    left: 0px;
    margin-bottom: -8px;
    margin-left: -4px;
  }
`}</style>

const SliderBarStyles = <style jsx='true'>{`
  .djn-sliderBar {
    position: absolute;
    background: #FF6D6B;
    border-radius: 4px;
  }

  .djn-sliderBar.horizontal {
    top: 0;
    bottom: 0;
    left: 0;
  }

  .djn-sliderBar.vertical {
    right: 0;
    bottom: 0;
    left: 0;
  }
`}</style>

// A colored bar that will represent the current value
const SliderBar = ({ direction, value, style }) => (
  <div
    style={Object.assign({}, direction === 'HORIZONTAL' ? {
      width: `${value * 100}%`,
    } : {
      height: `${value * 100}%`,
    })}
    className={`djn-sliderBar ${direction === 'HORIZONTAL' ? 'horizontal' : 'vertical'}`}
  />
)

// A handle to indicate the current value
const SliderHandle = ({ direction, value, style }) => (
  <div
    style={Object.assign({}, direction === 'HORIZONTAL' ? {
      left: `${value * 100}%`,
    } : {
      bottom: `${value * 100}%`,
    })}
    className={`djn-sliderHandle ${direction === 'HORIZONTAL' ? 'horizontal' : 'vertical'}`}
  />
)

// A composite progress bar component
const ProgressBar = ({ isEnabled, direction, value, ...props }) => (
  <Slider
    isEnabled={isEnabled}
    direction={direction}
    onChange={() => {}}
    style={{
      width: direction === 'HORIZONTAL' ? 200 : 8,
      height: direction === 'HORIZONTAL' ? 8 : 130,
      borderRadius: 4,
      background: '#593D46',
      transition: direction === 'HORIZONTAL' ? 'width 0.1s' : 'height 0.1s',
      cursor: isEnabled === true ? 'pointer' : 'default',
    }}
    {...props}
  >
    <SliderBar direction={direction} value={value} />
    <SliderHandle direction={direction} value={value} />
    {SliderHandleStyles}
    {SliderBarStyles}
  </Slider>
)

export default ProgressBar
