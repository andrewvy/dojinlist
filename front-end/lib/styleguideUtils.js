const Action = (name) => () => console.log(`[Action] ${name}`)

const HeaderStyles = 'uppercase text-grey font-mono'
const SubheaderStyles = `${HeaderStyles} my-4`

export {
  Action,
  HeaderStyles,
  SubheaderStyles
}
