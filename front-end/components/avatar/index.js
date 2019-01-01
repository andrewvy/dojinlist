const Avatar = (props) => (
  <div className='user-avatar'>
    <img src={props.user.avatar} />
    <style jsx>{`
      .user-avatar img {
        width: 24px;
        height: 24px;
        border-radius: 5px;
        margin-right: 4px;
      }
    `}</style>
  </div>
)

export default Avatar
