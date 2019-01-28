import Slider from './slider.js'
import FormattedTime from './formattedTime.js'

// Create a basic bar that represents time
const TimeBar = ({ children }) => (
  <div
    style={{
      height: 8,
      width: '100%',
      background: 'gray',
    }}
  >
    {children}
  </div>
)

// Create a tooltip that will show the time
const TimeTooltip = ({ numSeconds, style = {} }) => (
  <div
    style={{
      display: 'inline-block',
      position: 'absolute',
      bottom: '100%',
      height: 150,
      transform: 'translateX(-50%)',
      padding: 8,
      borderRadius: 3,
      background: 'darkblue',
      color: 'white',
      fontSize: 12,
      fontWeight: 'bold',
      lineHeight: 16,
      textAlign: 'center',
      ...style,
    }}
  >
    <FormattedTime numSeconds={numSeconds} />
  </div>
)

// Create a component to keep track of user interactions
class BarWithTimeOnHover extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      // This will be a normalised value between 0 and 1,
      // or null when not hovered
      hoverValue: null,
    }

    this.handleIntent = this.handleIntent.bind(this)
    this.handleIntentEnd = this.handleIntentEnd.bind(this)
  }

  handleIntent(value) {
    this.setState({
      hoverValue: value,
    })
  }

  handleIntentEnd() {
    // Note that this might not be invoked if the user ends
    // a control change with the mouse outside of the slider
    // element, so you might want to do this inside a
    // onChangeEnd callback too.
    this.setState({
      hoverValue: null,
    })
  }

  render() {
    const { duration } = this.props
    const { hoverValue } = this.state

    return (
      <Slider
        direction={'HORIZONTAL'}
        style={{
          position: 'relative',
        }}
        onIntent={this.handleIntent}
        onIntentEnd={this.handleIntentEnd}
      >
        <TimeBar />

        {hoverValue !== null && (
          <TimeTooltip
            numSeconds={hoverValue * duration}
            style={{
              left: `${hoverValue * 100}%`,
            }}
          />
        )}
      </Slider>
    )
  }
}

export default BarWithTimeOnHover
