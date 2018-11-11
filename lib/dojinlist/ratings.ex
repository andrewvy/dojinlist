defmodule Dojinlist.Ratings do
  alias Dojinlist.{
    Repo,
    Schemas
  }

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
end
