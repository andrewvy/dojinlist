const NextI18Next = require('next-i18next/dist/commonjs')

const NextI18NextInstance = new NextI18Next({
  defaultLanguage: 'en',
  otherLanguages: ['ja']
})

module.exports = NextI18NextInstance
