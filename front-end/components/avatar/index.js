const Avatar = ({ user, width, height, className }) => (
  <div className={`user-avatar ${className}`}>
    <img src={user.avatar} width={width} height={height} />

    <style jsx>{`
      .user-avatar img {
        border-radius: 5px;
        margin-right: 4px;
        border: 1px solid #E5E5E5;
      }
    `}</style>
  </div>
)

Avatar.defaultProps = {
  width: 24,
  height: 24
}

export default Avatar
