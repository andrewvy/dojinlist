import './index.css'

const Pill = ({ title, description, lightColor, darkColor, type }) => (
  <div className={`djn-pill ${type} font-sans bg-${lightColor} text-${darkColor}`}>
    <span className={`title bg-${darkColor} text-white`}>
      {title}
    </span>
    {
      description &&
      <span className='description'>
        {description}
      </span>
    }
  </div>
)

Pill.defaultProps = {
  type: 'standard'
}

export default Pill
