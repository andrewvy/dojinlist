import React, { PureComponent } from 'react'
import { Query } from 'react-apollo'

import FetchStorefrontQuery from '../queries/storefront/storefront.js'

import Page from '../layouts/main.js'

class HomePage extends PureComponent {
  static async getInitialProps({ query }) {
    return { query }
  }

  render() {
    const { subdomain } = this.props.query

    return (
      <Page>
        <div className='container'>
          <Query query={FetchStorefrontQuery} variables={{subdomain}}>
            {({data, loading}) => (
              <div>
                {loading && <div>Loading</div>}
                {
                  !loading &&
                    <div>
                      <p>Display Name: {data.storefront.display_name}</p>
                      <p>Description: {data.storefront.description}</p>
                    </div>
                }
              </div>
            )}
          </Query>
        </div>
      </Page>
    )
  }
}

export default HomePage
