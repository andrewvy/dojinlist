defmodule DojinlistWeb.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias Dojinlist.Repo
  alias DojinlistWeb.Resolvers

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
    field :name, :string
    field :description, :string
    field :release_date, :datetime
    field :sample_url, :string
    field :purchase_url, :string
    field :event, :event

    field :cover_art_url, :string do
      resolve(fn album, _, _ ->
        url = Dojinlist.ImageAttachment.url(album.cover_art, :standard)
        {:ok, Dojinlist.ImageAttachment.wrap_url_for_local(url)}
      end)
    end

    field :cover_art_thumb_url, :string do
      resolve(fn album, _, _ ->
        url = Dojinlist.ImageAttachment.url(album.cover_art, :thumb)
        {:ok, Dojinlist.ImageAttachment.wrap_url_for_local(url)}
      end)
    end

    field :genres, list_of(:genre)
    field :artists, list_of(:artist)
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

  node object(:artist) do
    field :uuid, :string
    field :name, :string
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
        url = Dojinlist.ImageAttachment.url(user.avatar, :thumb)
        {:ok, Dojinlist.ImageAttachment.wrap_url_for_local(url)}
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
        url = Dojinlist.ImageAttachment.url(user.avatar, :thumb)
        {:ok, Dojinlist.ImageAttachment.wrap_url_for_local(url)}
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
end
