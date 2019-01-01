defmodule Dojinlist.Schemas.Track do
  use Ecto.Schema

  import Ecto.Changeset

  schema "tracks" do
    field :romanized_title, :string
    field :japanese_title, :string
    field :play_length, :integer

    belongs_to :album, Dojinlist.Schemas.Album
  end

  def changeset(track, attrs) do
    track
    |> cast(attrs, [
      :romanized_title,
      :japanese_title,
      :play_length,
      :album_id
    ])
    |> validate_required([:japanese_title])
  end
end
