const TextInput = (props) => (
  <input className='input' type='text' placeholder={props.placeholder}>
    <style jsx>{`
      p {
        color: red;
      }
    `}</style>
  </input>
)

export default TextInput
