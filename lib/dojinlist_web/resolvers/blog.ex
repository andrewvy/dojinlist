defmodule DojinlistWeb.Resolvers.Blog do
  alias Dojinlist.Blog

  def all(params, _) do
    Blog.all_posts_query()
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end

  def by_slug(%{slug: slug}, _) do
    case Blog.by_slug(slug) do
      nil ->
        # @TODO(vy): i18n
        {:error, "Could not find a blog post with that slug"}

      blog_post ->
        {:ok, blog_post}
    end
  end
end
