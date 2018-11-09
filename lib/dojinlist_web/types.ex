defmodule DojinlistWeb.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  import_types(Absinthe.Type.Custom)

  connection(node_type: :album)

  node object(:album) do
    field :uuid, :string
    field :name, :string
    field :description, :string
    field :release_date, :datetime
    field :sample_url, :string
    field :purchase_url, :string

    connection field :genres, node_type: :genre do
      resolve(fn pagination_args, %{source: album} ->
        Absinthe.Relay.Connection.from_list(
          album.genres,
          pagination_args
        )
      end)
    end

    connection field :artists, node_type: :artist do
      resolve(fn pagination_args, %{source: album} ->
        Absinthe.Relay.Connection.from_list(
          album.genres,
          pagination_args
        )
      end)
    end
  end

  connection(node_type: :genre)

  node object(:genre) do
    field :uuid, :string
    field :name, :string
  end

  connection(node_type: :artist)

  node object(:artist) do
    field :uuid, :string
    field :name, :string
  end

  object :user do
    field :id, :id
    field :username, :string
    field :email, :string
  end

  object :login_response do
    field :token, :string
    field :user, :user
  end

  object :register_response do
    field :user, :user
  end
end
