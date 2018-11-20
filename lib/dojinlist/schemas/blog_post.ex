defmodule Dojinlist.Schemas.BlogPost do
  use Ecto.Schema

  import Ecto.Changeset

  schema "blog_posts" do
    belongs_to :user, Dojinlist.Schemas.User

    field :title, :string
    field :slug, :string
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(blog_post, attrs) do
    blog_post
    |> cast(attrs, [
      :user_id,
      :title,
      :slug,
      :content
    ])
    |> validate_required([:user_id, :title, :slug, :content])
    |> unique_constraint(:slug)
  end
end
