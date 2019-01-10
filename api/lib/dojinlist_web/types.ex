defmodule DojinlistWeb.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias Dojinlist.Repo
  alias DojinlistWeb.Resolvers

  import Absinthe.Resolution.Helpers

  import_types(Absinthe.Plug.Types)
  import_types(Absinthe.Type.Custom)

  connection node_type: :album do
    edge do
      field :personal_rating, :rating do
        resolve(&Resolvers.Rating.get_rating/3)
      end
    end
  end

  node object(:album) do
    field :uuid, :string
    field :title, :string
    field :release_datetime, :datetime
    field :event, :event, resolve: dataloader(Dojinlist.Source)

    field :cover_art_url, :string do
      resolve(fn album, _, _ ->
        url = Dojinlist.ImageAttachment.url(album.cover_art, :standard)
        {:ok, Dojinlist.Uploaders.wrap_url_for_local(url)}
      end)
    end

    field :cover_art_thumb_url, :string do
      resolve(fn album, _, _ ->
        url = Dojinlist.ImageAttachment.url(album.cover_art, :thumb)
        {:ok, Dojinlist.Uploaders.wrap_url_for_local(url)}
      end)
    end

    field :genres, list_of(:genre), resolve: dataloader(Dojinlist.Source)
    field :artists, list_of(:artist), resolve: dataloader(Dojinlist.Source)
    field :tracks, list_of(:track), resolve: dataloader(Dojinlist.Source)
    field :external_links, list_of(:external_album_link), resolve: dataloader(Dojinlist.Source)
  end

  connection(node_type: :genre)

  node object(:genre) do
    field :uuid, :string
    field :name, :string
  end

  connection(node_type: :artist)

  node object(:event) do
    field :uuid, :string
    field :name, :string
    field :start_date, :date
    field :end_date, :date
  end

  connection(node_type: :event)

  node object(:rating) do
    field :rating, :integer
    field :description, :string
    field :inserted_at, :datetime
    field :updated_at, :datetime
    field :album, :album
  end

  connection(node_type: :rating)

  connection(node_type: :blog_post)

  node object(:blog_post) do
    field :title, :string
    field :slug, :string
    field :content, :string
    field :summary, :string

    field :author, :user do
      resolve(fn post, _, _ ->
        {:ok, post.user}
      end)
    end

    field :inserted_at, :datetime
    field :updated_at, :datetime
  end

  connection(node_type: :lite_album)

  node object(:lite_album) do
    field :title, :string
  end

  node object(:artist) do
    field :uuid, :string
    field :name, :string
  end

  node object(:track) do
    field :title, :string
    field :play_length, :integer
    field :album, :album, resolve: dataloader(Dojinlist.Source)
  end

  node object(:external_album_link) do
    field :url, :string
    field :type, :external_album_link_type
  end

  enum :external_album_link_type do
    value(:official, as: "official", description: "A link to official resources")
    value(:store, as: "store", description: "A link to a store page")

    value(:store_physical_only,
      as: "store_physical_only",
      description: "A link to a store page, strictly for physical-only purchase"
    )

    value(:store_digital_only,
      as: "store_digital_only",
      description: "A link to a store page, strictly for digital-only purchase"
    )
  end

  node object(:storefront) do
    field :subdomain, :string
  end

  object :me do
    field :username, :string
    field :email, :string

    field :rating_count, :integer do
      resolve(fn _, %{context: %{current_user: user}} ->
        count =
          Dojinlist.Schemas.UserRating
          |> Dojinlist.Schemas.UserRating.where_user_id(user.id)
          |> Repo.aggregate(:count, :id)

        {:ok, count}
      end)
    end

    field :avatar, :string do
      resolve(fn user, _, _ ->
        url = Dojinlist.AvatarAttachment.url(user.avatar, :thumb)
        {:ok, Dojinlist.Uploaders.wrap_url_for_local(url)}
      end)
    end

    connection field :ratings, node_type: :rating do
      resolve(&Resolvers.Rating.get_ratings_by_user/2)
    end
  end

  object :user do
    field :id, :id
    field :username, :string
    field :email, :string

    field :avatar, :string do
      resolve(fn user, _, _ ->
        url = Dojinlist.AvatarAttachment.url(user.avatar, :thumb)
        {:ok, Dojinlist.Uploaders.wrap_url_for_local(url)}
      end)
    end
  end

  object :login_response do
    field :token, :string
    field :user, :user
  end

  object :register_response do
    field :user, :user
  end

  object :rating_like do
    field :user_id, :user
    field :rating_id, :rating
  end

  input_object :album_input do
    field :title, non_null(:string)
    field :artist_ids, list_of(:id)
    field :genre_ids, list_of(:id)
    field :storefront_id, non_null(:id)
    field :event_id, :id
    field :cover_art, :upload
    field :release_datetime, :datetime
    field :tracks, list_of(:track_input)
    field :external_links, list_of(:external_album_link_input)
  end

  input_object :external_album_link_input do
    field :url, :string
    field :type, :external_album_link_type
  end

  input_object :track_input do
    field :title, non_null(:string)
    field :play_length, :integer
  end

  input_object :storefront_input do
    field :subdomain, :string
  end
end
