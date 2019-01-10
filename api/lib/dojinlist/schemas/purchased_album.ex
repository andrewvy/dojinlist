defmodule Dojinlist.Schemas.PurchasedAlbum do
  use Ecto.Schema

  import Ecto.Changeset

  alias Dojinlist.Schemas.{
    Album,
    User,
    Transaction
  }

  schema "purchased_albums" do
    field :user_email, :string

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
      :transaction_id,
      :album_id
    ])
    |> validate_required_inclusion([:user_id, :user_email])
    |> unique_constraint(:user_id)
    |> unique_constraint(:email)
  end

  def validate_required_inclusion(changeset, fields) do
    if Enum.any?(fields, &present?(changeset, &1)) do
      changeset
    else
      add_error(changeset, hd(fields), "One of these fields must be present: #{inspect(fields)}")
    end
  end

  def present?(changeset, field) do
    value = get_field(changeset, field)
    value && value != ""
  end
end
