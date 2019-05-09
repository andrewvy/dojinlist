import './index.css'

const Label = ({ children, ...props }) => (
  <label className='djn-label' {...props}>
    {children}
  </label>
)

export default Label
