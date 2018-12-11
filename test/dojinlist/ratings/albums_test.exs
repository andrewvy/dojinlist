defmodule Dojinlist.Ratings.AlbumsTest do
  use Dojinlist.DataCase

  alias Dojinlist.Fixtures
  alias Dojinlist.Ratings

  setup do
    on_exit(fn ->
      Dojinlist.Ratings.Store.clean()
    end)
  end

  test "Weighted lifetime votes" do
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

    score_1 = Dojinlist.Ratings.Store.get(:albums_lifetime_scores, album_1.id)
    score_2 = Dojinlist.Ratings.Store.get(:albums_lifetime_scores, album_2.id)
    score_3 = Dojinlist.Ratings.Store.get(:albums_lifetime_scores, album_3.id)

    assert [{_, ^score_3}, {_, ^score_2}, {_, ^score_1}] =
             Dojinlist.Ratings.Store.top(:albums_lifetime_scores, 10)
  end

  test "Time-decayed votes" do
    {:ok, user_1} = Fixtures.user()
    {:ok, user_2} = Fixtures.user()
    {:ok, user_3} = Fixtures.user()

    {:ok, album_1} = Fixtures.album()
    {:ok, album_2} = Fixtures.album()
    {:ok, album_3} = Fixtures.album()

    time_1 = DateTime.utc_now()

    time_2 =
      Faker.Date.forward(7)
      |> NaiveDateTime.new(~T[00:00:00.000])
      |> elem(1)
      |> DateTime.from_naive!("Etc/UTC")

    time_3 =
      Faker.Date.forward(14)
      |> NaiveDateTime.new(~T[00:00:00.000])
      |> elem(1)
      |> DateTime.from_naive!("Etc/UTC")

    Ratings.create_rating(user_1, album_1, %{rating: 8, inserted_at: time_1})
    Ratings.create_rating(user_2, album_1, %{rating: 8, inserted_at: time_1})
    Ratings.create_rating(user_3, album_1, %{rating: 8, inserted_at: time_1})

    Ratings.create_rating(user_1, album_2, %{rating: 7, inserted_at: time_2})
    Ratings.create_rating(user_2, album_2, %{rating: 7, inserted_at: time_2})
    Ratings.create_rating(user_3, album_2, %{rating: 7, inserted_at: time_2})

    Ratings.create_rating(user_1, album_3, %{rating: 7, inserted_at: time_3})
    Ratings.create_rating(user_2, album_3, %{rating: 7, inserted_at: time_3})
    Ratings.create_rating(user_3, album_3, %{rating: 7, inserted_at: time_3})

    Dojinlist.Ratings.Albums.calculate()

    score_1 = Dojinlist.Ratings.Store.get(:albums_timed_scores, album_1.id)
    score_2 = Dojinlist.Ratings.Store.get(:albums_timed_scores, album_2.id)
    score_3 = Dojinlist.Ratings.Store.get(:albums_timed_scores, album_3.id)

    assert [{_, ^score_3}, {_, ^score_2}, {_, ^score_1}] =
             Dojinlist.Ratings.Store.top(:albums_timed_scores, 10)
  end
end
