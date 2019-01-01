defmodule Dojinlist.Blog do
  alias Dojinlist.Schemas.{
    BlogPost
  }

  alias Dojinlist.Repo

  import Ecto.Query

  def create_post(attrs) do
    %BlogPost{}
    |> BlogPost.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(post, attrs) do
    post
    |> BlogPost.changeset(attrs)
    |> Repo.update()
  end

  def by_id(id) do
    BlogPost
    |> Repo.get(id)
  end

  def by_slug(slug) do
    all_posts_query()
    |> where([p], p.slug == ^slug)
    |> Repo.one()
  end

  def delete_by_slug(slug) do
    BlogPost
    |> where([p], p.slug == ^slug)
    |> Repo.delete_all()
  end

  def all_posts_query() do
    BlogPost
    |> order_by(asc: :inserted_at)
    |> preload([p], [:user])
  end
end
