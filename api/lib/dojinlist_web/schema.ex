defmodule DojinlistWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  alias DojinlistWeb.{
    Middlewares,
    Mutations,
    Resolvers
  }

  import_types(DojinlistWeb.Types)
  import_types(Mutations.Album)
  import_types(Mutations.Artist)
  import_types(Mutations.Blog)
  import_types(Mutations.Checkout)
  import_types(Mutations.Event)
  import_types(Mutations.Genre)
  import_types(Mutations.Like)
  import_types(Mutations.Me)
  import_types(Mutations.Permission)
  import_types(Mutations.Rating)
  import_types(Mutations.Storefront)
  import_types(Mutations.Track)
  import_types(Mutations.OAuth)
  import_types(Mutations.Download)

  query do
    connection field(:albums, node_type: :album) do
      arg(:artist_ids, list_of(:id))
      arg(:genre_ids, list_of(:id))
      arg(:artist_names, list_of(:string))
      arg(:genre_names, list_of(:string))
      arg(:event_id, :id)
      arg(:storefront_id, :id)

      middleware(Absinthe.Relay.Node.ParseIDs, artist_ids: :artist)
      middleware(Absinthe.Relay.Node.ParseIDs, genre_ids: :genre)
      middleware(Absinthe.Relay.Node.ParseIDs, event_id: :event)
      middleware(Absinthe.Relay.Node.ParseIDs, storefront_id: :storefront)

      resolve(&Resolvers.Album.all/2)
    end

    field :album, :album do
      arg(:id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, id: :album)
      resolve(&Resolvers.Album.by_id/2)
    end

    field :me, :me do
      middleware(Middlewares.Authorization)

      resolve(&Resolvers.Me.fetch/2)
    end

    field :blog_post, :blog_post do
      arg(:slug, non_null(:string))

      resolve(&Resolvers.Blog.by_slug/2)
    end

    field :storefront, :storefront do
      arg(:subdomain, non_null(:string))

      resolve(&Resolvers.Storefront.by_subdomain/2)
    end

    connection field(:artists, node_type: :artist) do
      arg(:search, :string)

      resolve(&Resolvers.Artist.all/2)
    end

    connection field(:genres, node_type: :genre) do
      arg(:search, :string)

      resolve(&Resolvers.Genre.all/2)
    end

    connection field(:events, node_type: :event) do
      arg(:name, :string)

      resolve(&Resolvers.Event.all/2)
    end

    connection field(:blog_posts, node_type: :blog_post) do
      resolve(&Resolvers.Blog.all/2)
    end

    field :oauth_redirect_url, :string do
      arg(:oauth_provider, non_null(:string))

      middleware(Middlewares.Authorization)

      resolve(&Resolvers.OAuth.redirect_url/2)
    end
  end

  mutation do
    field :login, type: :login_response do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      middleware(Middlewares.Unauthorization)

      resolve(&Mutations.Authentication.login/2)
    end

    field :register, type: :register_response do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      arg(:username, non_null(:string))

      middleware(Middlewares.Unauthorization)
      resolve(&Mutations.Authentication.register/2)
    end

    field :confirm_email, type: :user do
      arg(:token, non_null(:string))

      resolve(&Mutations.Authentication.confirm_email/2)
    end

    import_fields(:album_mutations)
    import_fields(:blog_mutations)
    import_fields(:checkout_mutations)
    import_fields(:download_mutations)
    import_fields(:me_mutations)
    import_fields(:oauth_mutations)
    import_fields(:permission_mutations)
    import_fields(:storefront_mutations)
    import_fields(:track_mutations)

    # ---
    # Unreleased
    # ---
    #
    # import_fields(:artist_mutations)
    # import_fields(:event_mutations)
    # import_fields(:genre_mutations)

    # ---
    # Social Features
    # ---
    #
    # import_fields(:like_mutations)
    # import_fields(:rating_mutations)
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

      %Dojinlist.Schemas.BlogPost{}, _ ->
        :blog_post

      %Dojinlist.Schemas.UserLikeRating{}, _ ->
        :rating_like

      %Dojinlist.Schemas.Track{}, _ ->
        :track

      %Dojinlist.Schemas.Storefront{}, _ ->
        :storefront

      _, _ ->
        nil
    end)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Dojinlist.Source, Dojinlist.Source.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
