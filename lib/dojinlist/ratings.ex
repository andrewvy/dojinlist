defmodule Dojinlist.Ratings do
  alias Dojinlist.{
    Repo,
    Schemas
  }

  import Ecto.Query

  def create_rating(user, album, attrs) do
    merged_attrs =
      attrs
      |> Map.merge(%{
        user_id: user.id,
        album_id: album.id
      })

    %Schemas.UserRating{}
    |> Schemas.UserRating.changeset(merged_attrs)
    |> Repo.insert()
  end

  def get_by_id(id) do
    Schemas.UserRating
    |> Repo.get(id)
  end

  def delete_rating(rating) do
    rating
    |> Repo.delete()
  end

  def get_album_rating(user, album) do
    Schemas.UserRating
    |> where([ur], ur.user_id == ^user.id and ur.album_id == ^album.id)
    |> Repo.one()
  end
end
