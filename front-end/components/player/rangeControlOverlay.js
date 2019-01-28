import React, { Component } from 'react';

/**
 * An invisible overlay that acts as a range mouse control
 * within a specified bounds.
 */
class RangeControlOverlay extends Component {
  static defaultProps = {
    onChangeStart: () => {},
    onChangeEnd: () => {},
    onIntent: () => {},
    onIntentStart: () => {},
    onIntentEnd: () => {},
    direction: 'HORIZONTAL',
    className: null,
    style: {},
  };

  constructor(props) {
    super(props);

    this.state = {
      isDragging: false,
    };
  }

  componentWillUnmount() {
    this.endDrag();
  }

  startDrag(evt) {
    this.setState({isDragging: true});
    window.addEventListener('mousemove', this.triggerRangeChange.bind(this));
    window.addEventListener('mouseup', this.endDrag.bind(this));

    this.toggleSelection('none');

    const startValue = evt ? this.getValueFromMouseEvent(evt) : null;
    this.props.onChangeStart(startValue);
  }

  endDrag(evt) {
    if (evt) {
      this.triggerRangeChange(evt);
    }

    this.setState({isDragging: false});
    window.removeEventListener('mousemove', this.triggerRangeChange);
    window.removeEventListener('mouseup', this.endDrag);

    this.toggleSelection('');

    const endValue = evt ? this.getValueFromMouseEvent(evt) : null;
    this.props.onChangeEnd(endValue);
  }

  toggleSelection(value) {
    let body = document.getElementsByTagName('body')[0];
    body.style['user-select'] = value;
    body.style['-webkit-user-select'] = value;
    body.style['-moz-user-select'] = value;
    body.style['-ms-user-select'] = value;
  }

  getValueFromMouseEvent(mouseEvent) {
    return this.props.direction === 'VERTICAL'
      ? this.getVerticalValue(mouseEvent.pageY)
      : this.getHorizontalValue(mouseEvent.pageX);
  }

  triggerRangeChange(mouseEvent) {
    this.props.onChange(this.getValueFromMouseEvent(mouseEvent));
  }

  handleIntentStart(evt) {
    const {direction, onIntentStart} = this.props;

    if (!this.state.isDragging) {
      const value =
        direction === 'VERTICAL'
          ? this.getVerticalValue(evt.pageY)
          : this.getHorizontalValue(evt.pageX);

      onIntentStart(value);
    }
  }

  handleIntentMove(evt) {
    const {direction, onIntent} = this.props;

    if (!this.state.isDragging) {
      const value =
        direction === 'VERTICAL'
          ? this.getVerticalValue(evt.pageY)
          : this.getHorizontalValue(evt.pageX);

      onIntent(value);
    }
  }

  handleIntentEnd(evt) {
    const {onIntentEnd} = this.props;

    if (!this.state.isDragging) {
      onIntentEnd();
    }
  }

  getRectFromBounds() {
    const {bounds} = this.props;

    return typeof bounds === 'function' ? bounds() : bounds;
  }

  getHorizontalValue(mouseX) {
    const rect = this.getRectFromBounds();
    const scrollX =
      window.pageXOffset !== undefined
        ? window.pageXOffset
        : (
            document.documentElement ||
            document.body.parentNode ||
            document.body
          ).scrollLeft;
    let dLeft = mouseX - (rect.left + scrollX);
    dLeft = Math.max(dLeft, 0);
    dLeft = Math.min(dLeft, rect.width);

    return dLeft / rect.width;
  }

  getVerticalValue(mouseY) {
    const rect = this.getRectFromBounds();
    const scrollY =
      window.pageYOffset !== undefined
        ? window.pageYOffset
        : (
            document.documentElement ||
            document.body.parentNode ||
            document.body
          ).scrollTop;
    let dTop = mouseY - (rect.top + scrollY);
    dTop = Math.max(dTop, 0);
    dTop = Math.min(dTop, rect.height);

    return 1 - dTop / rect.height;
  }

  render() {
    const {className, style} = this.props;

    return (
      <div
        className={className}
        style={style}
        onMouseDown={this.startDrag.bind(this)}
        onMouseEnter={this.handleIntentStart.bind(this)}
        onMouseMove={this.handleIntentMove.bind(this)}
        onMouseLeave={this.handleIntentEnd.bind(this)}
      />
    );
  }
}

export default RangeControlOverlay;
