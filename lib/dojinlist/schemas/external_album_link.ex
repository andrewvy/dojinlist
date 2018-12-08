defmodule Dojinlist.Schemas.ExternalAlbumLink do
  use Ecto.Schema

  import Ecto.Changeset

  schema "external_album_links" do
    field :url, :string
    field :type, :string

    belongs_to :album, Dojinlist.Schemas.Album
  end

  def changeset(link, attrs) do
    link
    |> cast(attrs, [
      :url,
      :type,
      :album_id
    ])
    |> update_change(:type, &String.downcase/1)
    |> validate_inclusion(:type, link_types())
    |> validate_required([
      :url,
      :type
    ])
  end

  def link_types() do
    [
      "official",
      "store",
      "store_physical_only",
      "store_digital_only"
    ]
  end
end
