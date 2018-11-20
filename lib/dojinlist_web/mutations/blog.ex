defmodule DojinlistWeb.Mutations.Blog do
  use Absinthe.Schema.Notation

  object :blog_mutations do
    field :create_blog_post, type: :blog_post do
      arg(:title, non_null(:string))
      arg(:slug, non_null(:string))
      arg(:content, non_null(:string))
      arg(:summary, :string)

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(DojinlistWeb.Middlewares.Permission, permission: "manage_blog")

      resolve(&create_post/2)
    end

    field :update_blog_post, type: :blog_post do
      arg(:id, non_null(:id))
      arg(:title, non_null(:string))
      arg(:slug, non_null(:string))
      arg(:content, non_null(:string))
      arg(:summary, :string)

      middleware(Absinthe.Relay.Node.ParseIDs, id: :blog_post)
      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(DojinlistWeb.Middlewares.Permission, permission: "manage_blog")

      resolve(&update_post/2)
    end
  end

  def create_post(attrs, %{context: %{current_user: user}}) do
    merged_attrs =
      Map.merge(attrs, %{
        user_id: user.id
      })

    case Dojinlist.Blog.create_post(merged_attrs) do
      {:ok, post} ->
        {:ok, Map.merge(post, %{author: user})}

      {:error, _changeset} ->
        # @TODO(vy): i18n
        {:error, "Could not create post"}
    end
  end

  def update_post(attrs, _) do
    case Dojinlist.Blog.by_id(attrs.id) do
      nil ->
        {:error, "Could not find blog post with that id"}

      post ->
        Dojinlist.Blog.update_post(post, attrs)
    end
  end
end
