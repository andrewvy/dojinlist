import { Link } from '../../routes.js'

import withOnlyAuthenticated from '../../lib/onlyAuthenticated'
import { withNamespaces } from '../../lib/i18n'

import Pill from '../../components/pill'
import Button from '../../components/button'

import DashboardLayout from '../../layouts/dashboard'

import './albums.css'

const AlbumsPage = ({ t }) => (
  <DashboardLayout type='albums'>
    {({me}) => (
      <div className='djn-dashboardAlbumsPage'>
        <div className='header'>
          <Pill
            darkColor='blue'
            type='bare'
            title={`${me.storefront.albums.length} album(s)`}
          />

          <div className='controls'>
            <Link route='dashboard_new_album'>
              <Button type='translucent' text={t('add-album-btn')} icon='plus' className='new-album'/>
            </Link>
          </div>
        </div>

        <table className='djn-table'>
          <thead>
            <tr>
              <td />
              <td>{t('album-title')}</td>
              <td>{t('album-tracks')}</td>
              <td>{t('album-date-uploaded')}</td>
              <td>{t('album-price')}</td>
              <td>{t('album-status')}</td>
              <td />
            </tr>
          </thead>
          <tbody>
            {me.storefront.albums.map((album) => (
              <tr key={album.id}>
                <td>
                <img src={album.coverArtThumbUrl} width={40} height={40} className='cover-art rounded' />
                </td>
                <td>{album.title}</td>
                <td>{album.tracks.length} Track(s)</td>
                <td>09 Apr 2019</td>
                <td>{album.price.amount}</td>
                <td>
                  <Pill
                    darkColor='grey'
                    type='bare'
                    title={album.status || 'pending'}
                  />
                </td>
                <td>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    )}
  </DashboardLayout>
)

const Wrapper = withOnlyAuthenticated(AlbumsPage)

Wrapper.getInitialProps = async () => {
  return {
    namespacesRequired: ['dashboard'],
  }
}

export default withNamespaces('dashboard')(Wrapper)
