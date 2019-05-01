defmodule DojinlistWeb.Mutations.Storefront do
  use Absinthe.Schema.Notation

  object :storefront_mutations do
    field :create_storefront, type: :storefront do
      arg(:storefront, non_null(:storefront_input))

      middleware(DojinlistWeb.Middlewares.Authorization)

      resolve(&create_storefront/2)
    end

    field :upload_storefront_avatar, type: :storefront do
      arg(:avatar, non_null(:upload))
      arg(:storefront_id, non_null(:id))

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(Absinthe.Relay.Node.ParseIDs, storefront_id: :storefront)
      middleware(DojinlistWeb.Middlewares.StorefrontAuthorized, storefront_id: :storefront)

      resolve(&upload_avatar/2)
    end

    field :upload_storefront_banner, type: :storefront do
      arg(:banner, non_null(:upload))
      arg(:storefront_id, non_null(:id))

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(Absinthe.Relay.Node.ParseIDs, storefront_id: :storefront)
      middleware(DojinlistWeb.Middlewares.StorefrontAuthorized, storefront_id: :storefront)

      resolve(&upload_banner/2)
    end
  end

  def create_storefront(%{storefront: storefront_attrs}, %{context: %{current_user: user}}) do
    merged_attrs =
      %{
        creator_id: user.id
      }
      |> Map.merge(storefront_attrs)

    case Dojinlist.Storefront.create_storefront(merged_attrs) do
      {:ok, storefront} -> {:ok, storefront}
      # @TODO(vy): i18n
      {:error, _} -> {:error, "Could not create storefront"}
    end
  end

  def upload_avatar(attrs, %{context: %{current_user: _, storefront: storefront}}) do
    with {:ok, avatar} <- handle_avatar(attrs[:avatar]),
         attrs = %{avatar_image: avatar},
         {:ok, storefront} <- Dojinlist.Storefront.update_storefront(storefront, attrs) do
      {:ok, storefront}
    else
      {:error, _} = error -> error
    end
  end

  def handle_avatar(avatar) do
    Dojinlist.Uploaders.rewrite_upload(avatar)
    |> Dojinlist.AvatarAttachment.store()
  end

  def upload_banner(attrs, %{context: %{current_user: _, storefront: storefront}}) do
    with {:ok, banner} <- handle_banner(attrs[:banner]),
         attrs = %{banner_image: banner},
         {:ok, storefront} <- Dojinlist.Storefront.update_storefront(storefront, attrs) do
      {:ok, storefront}
    else
      {:error, _} = error -> error
    end
  end

  def handle_banner(banner) do
    Dojinlist.Uploaders.rewrite_upload(banner)
    |> Dojinlist.BannerAttachment.store()
  end
end
