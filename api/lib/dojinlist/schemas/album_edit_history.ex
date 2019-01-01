defmodule Dojinlist.Schemas.AlbumEditHistory do
  use Ecto.Schema

  import Ecto.Changeset

  schema "albums_edit_history" do
    belongs_to :album, Dojinlist.Schemas.Album
    belongs_to :user, Dojinlist.Schemas.User

    field :edit_type, :string
    timestamps(type: :utc_datetime)
  end

  @album_edit_types [
    "submitted_album",
    "edit_album",
    "verify_album",
    "unverify_album"
  ]

  def changeset(edit_history, attrs) do
    edit_history
    |> cast(attrs, [
      :album_id,
      :user_id,
      :edit_type
    ])
    |> validate_required([
      :album_id,
      :user_id,
      :edit_type
    ])
    |> validate_inclusion(:edit_type, @album_edit_types)
  end
end