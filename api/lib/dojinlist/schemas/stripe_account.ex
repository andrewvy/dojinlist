defmodule Dojinlist.Schemas.StripeAccount do
  use Ecto.Schema

  import Ecto.Changeset

  schema "stripe_accounts" do
    field :access_token, :string
    field :scope, :string
    field :livemode, :boolean
    field :refresh_token, :string
    field :stripe_user_id, :string
    field :stripe_publishable_key, :string

    belongs_to :user, Dojinlist.Schemas.User
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [
      :access_token,
      :scope,
      :livemode,
      :refresh_token,
      :stripe_user_id,
      :stripe_publishable_key,
      :user_id
    ])
    |> unique_constraint(:user_id)
  end
end
