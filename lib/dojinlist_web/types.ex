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
    field :start_date, :datetime
    field :end_date, :datetime
  end

  connection(node_type: :event)

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
