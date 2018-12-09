defmodule Dojinlist.Ratings.AlbumsTest do
  use Dojinlist.DataCase

  alias Dojinlist.Fixtures
  alias Dojinlist.Ratings

  test "Weighted votes" do
    {:ok, user_1} = Fixtures.user()
    {:ok, user_2} = Fixtures.user()
    {:ok, user_3} = Fixtures.user()

    {:ok, album_1} = Fixtures.album()
    {:ok, album_2} = Fixtures.album()
    {:ok, album_3} = Fixtures.album()

    Ratings.create_rating(user_1, album_1, %{rating: 7})
    Ratings.create_rating(user_2, album_1, %{rating: 0})
    Ratings.create_rating(user_3, album_1, %{rating: 9})

    Ratings.create_rating(user_1, album_2, %{rating: 7})
    Ratings.create_rating(user_2, album_2, %{rating: 7})
    Ratings.create_rating(user_3, album_2, %{rating: 7})

    Ratings.create_rating(user_1, album_3, %{rating: 9})
    Ratings.create_rating(user_2, album_3, %{rating: 7})
    Ratings.create_rating(user_3, album_3, %{rating: 8})

    Dojinlist.Ratings.Albums.calculate()

    score_1 = Dojinlist.Ratings.Store.get(:albums, album_1.id)
    score_2 = Dojinlist.Ratings.Store.get(:albums, album_2.id)
    score_3 = Dojinlist.Ratings.Store.get(:albums, album_3.id)

    assert [^score_1, ^score_2, ^score_3] = Enum.sort([score_1, score_2, score_3])
  end
end
