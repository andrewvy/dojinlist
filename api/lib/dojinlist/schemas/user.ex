defmodule Dojinlist.Schemas.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field(:uuid, Ecto.UUID, autogenerate: true)
    field(:username, :string)
    field(:password, :string)
    field(:email, :string)
    field(:avatar, :string)

    field(:confirmation_token, :string)
    field(:confirmed_at, :utc_datetime)
    field(:confirmation_sent_at, :utc_datetime)

    many_to_many(:permissions, Dojinlist.Schemas.Permission, join_through: "users_permissions")

    has_one(:stripe_account, Dojinlist.Schemas.StripeAccount)

    has_many(:ratings, Dojinlist.Schemas.UserRating)
    has_many(:albums, through: [:ratings, :album])

    belongs_to(:storefront, Dojinlist.Schemas.Storefront)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :username,
      :email,
      :avatar,
      :confirmation_token,
      :confirmed_at,
      :confirmation_sent_at,
      :storefront_id
    ])
    |> cast_assoc(:storefront)
    |> put_password(attrs)
    |> validate_required([:username, :email])
    |> validate_username()
    |> validate_email()
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  def put_password(changeset, attrs) do
    password = Map.get(attrs, :password) || Map.get(attrs, "password")

    if password do
      if String.length(password) > 5 do
        hashed_password =
          password
          |> Argon2.hash_pwd_salt()

        put_change(changeset, :password, hashed_password)
      else
        add_error(changeset, :password, "Password must be a minimum length of 5")
      end
    else
      changeset
    end
  end

  def validate_username(changeset) do
    validate_change(changeset, :username, fn _, username ->
      case Regex.scan(~r/^\S*$/, username) do
        [] -> [{:name, "Invalid username"}]
        _ -> []
      end
    end)
  end

  def validate_email(changeset) do
    changeset
    |> validate_change(:email, fn _, email ->
      case Regex.scan(~r/@/, email) do
        [] -> [{:email, "Invalid email"}]
        _ -> []
      end
    end)
  end
end
