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
    field(:uuid, :string)
    field(:title, :string)
    field(:slug, :string)
    field(:release_datetime, :datetime)
    field(:event, :event, resolve: dataloader(Dojinlist.Source))

    field :purchasable, :boolean do
      resolve(fn album, _, _ ->
        {:ok, Dojinlist.Payments.recipient_payable?(album)}
      end)
    end

    field(:purchased, :boolean, resolve: &Resolvers.Album.already_purchased?/3)

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

    field(:storefront, :storefront, resolve: dataloader(Dojinlist.Source))

    field(:genres, list_of(:genre), resolve: dataloader(Dojinlist.Source))
    field(:artists, list_of(:artist), resolve: dataloader(Dojinlist.Source))
    field(:tracks, list_of(:track), resolve: dataloader(Dojinlist.Source))
    field(:external_links, list_of(:external_album_link), resolve: dataloader(Dojinlist.Source))
  end

  connection(node_type: :genre)

  node object(:genre) do
    field(:uuid, :string)
    field(:name, :string)
  end

  connection(node_type: :artist)

  node object(:event) do
    field(:uuid, :string)
    field(:name, :string)
    field(:start_date, :date)
    field(:end_date, :date)
  end

  connection(node_type: :event)

  node object(:rating) do
    field(:rating, :integer)
    field(:description, :string)
    field(:inserted_at, :datetime)
    field(:updated_at, :datetime)
    field(:album, :album)
  end

  connection(node_type: :rating)

  connection(node_type: :blog_post)

  node object(:blog_post) do
    field(:title, :string)
    field(:slug, :string)
    field(:content, :string)
    field(:summary, :string)

    field :author, :user do
      resolve(fn post, _, _ ->
        {:ok, post.user}
      end)
    end

    field(:inserted_at, :datetime)
    field(:updated_at, :datetime)
  end

  connection(node_type: :lite_album)

  node object(:lite_album) do
    field(:title, :string)
  end

  node object(:artist) do
    field(:uuid, :string)
    field(:name, :string)
  end

  node object(:track) do
    field(:title, :string)
    field(:play_length, :integer)
    field(:album, :album, resolve: dataloader(Dojinlist.Source))
    field(:position, :integer)
  end

  node object(:external_album_link) do
    field(:url, :string)
    field(:type, :external_album_link_type)
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
    field(:description, :string)
    field(:display_name, :string)
    field(:location, :string)
    field(:slug, :string)
  end

  object :me do
    field(:username, :string)
    field(:email, :string)

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

    connection field(:ratings, node_type: :rating) do
      resolve(&Resolvers.Rating.get_ratings_by_user/2)
    end
  end

  object :user do
    field(:id, :id)
    field(:username, :string)
    field(:email, :string)

    field :avatar, :string do
      resolve(fn user, _, _ ->
        url = Dojinlist.AvatarAttachment.url(user.avatar, :thumb)
        {:ok, Dojinlist.Uploaders.wrap_url_for_local(url)}
      end)
    end
  end

  object :login_response do
    field(:token, :string)
    field(:user, :user)
  end

  object :register_response do
    field(:user, :user)
  end

  object :rating_like do
    field(:user_id, :user)
    field(:rating_id, :rating)
  end

  input_object :album_input do
    field(:title, non_null(:string))
    field(:slug, non_null(:string))
    field(:artist_ids, list_of(:id))
    field(:genre_ids, list_of(:id))
    field(:storefront_id, non_null(:id))
    field(:event_id, :id)
    field(:cover_art, :upload)
    field(:release_datetime, :datetime)
    field(:tracks, list_of(:track_input))
    field(:external_links, list_of(:external_album_link_input))
  end

  input_object :external_album_link_input do
    field(:url, :string)
    field(:type, :external_album_link_type)
  end

  input_object :track_input do
    field(:title, non_null(:string))
    field(:source_file, :upload)
    field(:position, :integer)
    field(:play_length, :integer)
  end

  input_object :track_update_input do
    field(:title, non_null(:string))
    field(:play_length, :integer)
    field(:position, :integer)
  end

  input_object :storefront_input do
    field(:slug, non_null(:string))
    field(:description, :string)
    field(:display_name, :string)
    field(:location, :string)
  end

  object :oauth_response do
    field(:oauth_provider, non_null(:string))
    field(:user, :user)
    field(:errors, list_of(:error))
  end

  object :error do
    field(:error_code, non_null(:string))
    field(:error_message, non_null(:string))
  end

  enum :encodings do
    value(:mp3_320, as: "mp3-320")
    value(:mp3_128, as: "mp3-128")
    value(:mp3_v0, as: "mp3-v0")
    value(:flac, as: "flac")
  end

  input_object :download_album_input do
    field(:album_id, non_null(:id))
    field(:encoding, non_null(:encodings))
  end

  input_object :download_track_input do
    field(:track_id, non_null(:id))
    field(:encoding, non_null(:encodings))
  end

  object :download_response do
    field(:url, :string)
    field(:errors, list_of(:error))
  end

  object :cart_totals do
    field(:sub_total, :money)
    field(:tax_total, :money)
    field(:shipping_total, :money)
    field(:grand_total, :money)
  end

  object :track_response do
    field(:track, :track)
    field(:errors, list_of(:error))
  end

  object :cart_totals_response do
    field(:cart_totals, non_null(:cart_totals))
    field(:errors, list_of(:error))
  end

  object :checkout_response do
    field(:transaction_id, :string)
    field(:errors, list_of(:error))
  end

  object :money do
    field(:amount, non_null(:string))
    field(:currency, non_null(:string))
  end
end
