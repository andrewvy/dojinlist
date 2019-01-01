const Styles = () => (
  <style jsx>{`
    .user-details {
      height: 80px;
      margin-bottom: 16px;
      box-sizing: border-box;
      padding: 12px 0;
    }

    .user-details .container {
      display: flex;
      align-items: center;
    }

    .user-details .user-avatar,
    .user-details .user-avatar img {
      width: 50px;
      height: 50px;
      border-radius: 5px;
    }

    .user-details-inner {
      margin-left: 8px;
    }

    .user-details-inner .user-username,
    .user-details-inner .user-role {
      font-weight: 600;
    }
  `}</style>
)

const UserDetails = (props) => (
  <div className='user-details bg-grey-lighter'>
    <div className='container'>
      <div className='user-avatar'>
        <img src={props.user && props.user.avatar} />
      </div>
      <div className='user-details-inner'>
        <div className='user-username text-grey-dark'>
          {props.user && props.user.username}
        </div>
        <div className='user-role text-grey-orange'>
          Supporter
        </div>
      </div>
    </div>
    <Styles />
  </div>
)

export default UserDetails
