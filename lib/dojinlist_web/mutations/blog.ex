defmodule DojinlistWeb.Mutations.Blog do
  use Absinthe.Schema.Notation

  object :blog_mutations do
    field :create_blog_post, type: :blog_post do
      arg(:title, non_null(:string))
      arg(:slug, non_null(:string))
      arg(:content, non_null(:string))

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(DojinlistWeb.Middlewares.Permission, permission: "manage_blog")

      resolve(&create_post/2)
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
end
