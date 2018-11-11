defmodule DojinlistWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  alias DojinlistWeb.Resolvers
  alias DojinlistWeb.Mutations

  import_types(DojinlistWeb.Types)
  import_types(DojinlistWeb.Mutations.Album)
  import_types(DojinlistWeb.Mutations.Genre)
  import_types(DojinlistWeb.Mutations.Artist)

  query do
    connection field :albums, node_type: :album do
      resolve(&Resolvers.Album.all/2)
    end

    connection field :artists, node_type: :artist do
      resolve(&Resolvers.Artist.all/2)
    end

    connection field :genres, node_type: :genre do
      resolve(&Resolvers.Genre.all/2)
    end

    connection field :events, node_type: :event do
      resolve(&Resolvers.Event.all/2)
    end
  end

  mutation do
    field :login, type: :login_response do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      middleware(Dojinlist.Middlewares.Unauthorization)
      resolve(&Mutations.Authentication.login/2)
    end

    field :register, type: :register_response do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      arg(:username, non_null(:string))

      middleware(Dojinlist.Middlewares.Unauthorization)
      resolve(&Mutations.Authentication.register/2)
    end

    import_fields(:album_mutations)
    import_fields(:artist_mutations)
    import_fields(:genre_mutations)
  end

  node interface do
    resolve_type(fn
      %Dojinlist.Schemas.User{}, _ ->
        :user

      %Dojinlist.Schemas.Album{}, _ ->
        :album

      %Dojinlist.Schemas.Artist{}, _ ->
        :artist

      %Dojinlist.Schemas.Genre{}, _ ->
        :genre

      _, _ ->
        nil
    end)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
