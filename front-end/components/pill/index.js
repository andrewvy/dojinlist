import './index.css'

const Pill = ({ title, description, lightColor, darkColor }) => (
  <div className={`djn-pill font-sans bg-${lightColor} text-${darkColor}`}>
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

export default Pill
