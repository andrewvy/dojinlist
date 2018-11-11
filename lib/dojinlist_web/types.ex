defmodule DojinlistWeb.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias DojinlistWeb.Resolvers

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

  node object(:rating) do
    field :rating, :integer
    field :description, :string
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  connection(node_type: :rating)

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
