defmodule Dojinlist.RatingsTest do
  use Dojinlist.DataCase, async: true

  alias Dojinlist.{
    Ratings,
    Repo
  }

  test "A user can rate albums" do
    {:ok, user} = Dojinlist.Fixtures.user()
    {:ok, album} = Dojinlist.Fixtures.album()

    {:ok, created_rating} =
      Ratings.create_rating(user, album, %{
        rating: 5,
        description: "Good album!"
      })

    loaded_user = user |> Repo.preload([:ratings, :albums])

    assert [rating] = loaded_user.ratings
    assert rating.album_id == album.id
    assert rating.user_id == user.id
    assert rating.rating == created_rating.rating
    assert rating.description == created_rating.description
    assert [user_album] = loaded_user.albums
    assert user_album.id == album.id
  end
end
