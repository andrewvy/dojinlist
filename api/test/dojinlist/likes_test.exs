defmodule Dojinlist.LikesTest do
  use Dojinlist.DataCase

  alias Dojinlist.{
    Likes,
    Ratings
  }

  test "A user can like a rating" do
    {:ok, author} = Dojinlist.Fixtures.user()
    {:ok, album} = Dojinlist.Fixtures.album()
    {:ok, user} = Dojinlist.Fixtures.user()

    {:ok, created_rating} =
      Ratings.create_rating(author, album, %{
        rating: 5,
        description: "Good album!"
      })

    assert {:ok, like} = Likes.like_rating(user.id, created_rating.id)
  end
end
