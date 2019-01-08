defmodule Dojinlist.Schemas.PurchasedAlbum do
  use Ecto.Schema

  import Ecto.Changeset

  alias Dojinlist.Schemas.{
    Album,
    User,
    Transaction
  }

  schema "purchased_albums" do
    belongs_to(:user, User)
    belongs_to(:transaction, Transaction)
    belongs_to(:album, Album)

    timestamps(type: :utc_datetime)
  end

  def changeset(purchased_album, attrs) do
    purchased_album
    |> cast(attrs, [
      :user_id,
      :transaction_id,
      :album_id
    ])
    |> validate_required([
      :user_id,
      :transaction_id,
      :album_id
    ])
    |> unique_constraint(:user_id)
  end
end
