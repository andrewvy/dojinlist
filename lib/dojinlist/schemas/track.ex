defmodule Dojinlist.Schemas.Track do
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset

  schema "tracks" do
    field :title, :string
    field :kana_title, :string
    field :play_length, :integer

    belongs_to :album, Dojinlist.Schemas.Album
  end

  def changeset(track, attrs) do
    track
    |> cast(attrs, [
      :title,
      :kana_title,
      :play_length,
      :album_id
    ])
    |> validate_required([:kana_title])
  end
end
