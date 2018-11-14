defmodule DojinlistWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  alias DojinlistWeb.Resolvers
  alias DojinlistWeb.Mutations

  import_types(DojinlistWeb.Types)
  import_types(DojinlistWeb.Mutations.Album)
  import_types(DojinlistWeb.Mutations.Genre)
  import_types(DojinlistWeb.Mutations.Artist)
  import_types(DojinlistWeb.Mutations.Rating)
  import_types(DojinlistWeb.Mutations.Event)

  query do
    connection field :albums, node_type: :album do
      arg(:artist_ids, list_of(:id))
      arg(:genre_ids, list_of(:id))
      arg(:artist_names, list_of(:string))
      arg(:genre_names, list_of(:string))

      middleware(Absinthe.Relay.Node.ParseIDs, artist_ids: :artist)
      middleware(Absinthe.Relay.Node.ParseIDs, genre_ids: :genre)

      resolve(&Resolvers.Album.all/2)
    end

    connection field :unverified_albums, node_type: :album do
      resolve(&Resolvers.Album.unverified/2)
    end

    field :album, :album do
      arg(:id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, id: :album)
      resolve(&Resolvers.Album.by_id/2)
    end

    field :me, :me do
      middleware(Dojinlist.Middlewares.Authorization)

      resolve(&Resolvers.Me.fetch/2)
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
    import_fields(:rating_mutations)
    import_fields(:event_mutations)
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

      %Dojinlist.Schemas.Event{}, _ ->
        :event

      %Dojinlist.Schemas.UserRating{}, _ ->
        :rating

      _, _ ->
        nil
    end)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
