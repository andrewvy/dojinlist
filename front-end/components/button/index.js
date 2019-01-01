import Spinner from '../spinner'

const Button = (props) => {
  const {
    children,
    isLoading,
    className,
    onClick,
    type
  } = props

  return (
    <button className={`button button-primary ${className}`} onClick={onClick} type={type}>
      {
        isLoading &&
        <div className='spinner'>
          <Spinner color='grey-lighter' size='small'/>
        </div>
      }
      {!isLoading && children}
      <style jsx>{`
        .button {
          width: 100%;
          margin: 4px 0;
        }

        .spinner {
          position: relative;
          top: 3px;
        }
      `}</style>
    </button>
  )
}

Button.defaultProps = {
  type: 'submit'
}

export default Button
