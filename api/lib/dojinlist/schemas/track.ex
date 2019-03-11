defmodule Dojinlist.Schemas.Track do
  use Ecto.Schema

  import Ecto.Changeset

  @track_statuses [
    "pending",
    "submitted",
    "transcoded_failure",
    "completed"
  ]

  schema "tracks" do
    field(:title, :string)
    field(:play_length, :integer)
    field(:source_file, :string)
    field(:status, :string, default: "pending")
    field(:position, :integer, default: 0)
    field(:transcoder_hash, :string, default: "")

    belongs_to(:album, Dojinlist.Schemas.Album)
  end

  def changeset(track, attrs) do
    track
    |> cast(attrs, [
      :title,
      :play_length,
      :album_id,
      :source_file,
      :status,
      :position,
      :transcoder_hash
    ])
    |> validate_inclusion(:status, @track_statuses)
    |> validate_required([:title, :position])
  end
end
