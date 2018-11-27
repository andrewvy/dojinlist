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
        {:ok, Dojinlist.Uploaders.wrap_url_for_local(url)}
      end)
    end

    field :cover_art_thumb_url, :string do
      resolve(fn album, _, _ ->
        url = Dojinlist.ImageAttachment.url(album.cover_art, :thumb)
        {:ok, Dojinlist.Uploaders.wrap_url_for_local(url)}
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
    field :name, :string
  end

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
end
