const offset = 125

const Sizes = {
  small: 32,
  medium: 48,
  large: 64
}

const Spinner = (props) => {
  const { color, size } = props
  const computedSize = Sizes[size] || Sizes.medium
  const classColor = `text-${color}`

  return (
    <span className={`spinner ${classColor}`}>
      <svg height={computedSize} width={computedSize}>
        <circle cx={computedSize/2} cy={computedSize/2} r={computedSize/4} strokeWidth='2' fill='none' />
      </svg>
      <style jsx>{`
        .spinner {
          transform: rotate(-90deg);
          stroke: currentColor;
        }

        .spinner circle {
          stroke-dasharray: ${offset};
          stroke-dashoffset: ${offset};
          animation: dash 1.5s infinite;
        }

        @keyframes dash {
          50% {
            stroke-dashoffset: 0;
          }
          100% {
            stroke-dashoffset: -${offset};
          }
        }
      `}</style>
    </span>
  )
}

export default Spinner
