defmodule Dojinlist.Ratings.AlbumsTest do
  use Dojinlist.DataCase

  alias Dojinlist.Fixtures

  alias Dojinlist.{
    Ratings,
    Genres
  }

  setup do
    on_exit(fn ->
      Dojinlist.Ratings.Store.clean()
    end)

    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
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

    # We should expect that Album 3 should have a top score, since it was
    # rated recently even when Album 1 has a higher overall average rating.

    Dojinlist.Ratings.Albums.calculate()

    score_1 = Dojinlist.Ratings.Store.get(:albums_timed_scores, album_1.id)
    score_2 = Dojinlist.Ratings.Store.get(:albums_timed_scores, album_2.id)
    score_3 = Dojinlist.Ratings.Store.get(:albums_timed_scores, album_3.id)

    assert [{_, ^score_3}, {_, ^score_2}, {_, ^score_1}] =
             Dojinlist.Ratings.Store.top(:albums_timed_scores, 10)
  end

  test "Time-decayed votes by genre" do
    {:ok, user_1} = Fixtures.user()
    {:ok, user_2} = Fixtures.user()
    {:ok, user_3} = Fixtures.user()

    {:ok, genre_1} = Genres.create_genre(%{name: "Electronic"})
    {:ok, genre_2} = Genres.create_genre(%{name: "Classical"})

    {:ok, album_1} = Fixtures.album(%{genre_ids: [genre_1.id, genre_2.id]})
    {:ok, album_2} = Fixtures.album(%{genre_ids: [genre_1.id]})
    {:ok, album_3} = Fixtures.album(%{genre_ids: [genre_2.id]})

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

    # Higher score, but not recent. Should be last.
    score_1 = Dojinlist.Ratings.Store.get(:albums_timed_scores, album_1.id)

    # Second-most recent.
    _score_2 = Dojinlist.Ratings.Store.get(:albums_timed_scores, album_2.id)

    # Even more recent.
    score_3 = Dojinlist.Ratings.Store.get(:albums_timed_scores, album_3.id)

    # Get top rated recent albums filtered by genre.
    assert [{_, ^score_3}, {_, ^score_1}] =
             Dojinlist.Ratings.Albums.top_by_genre_id(:albums_timed_scores, genre_2.id, 10)
  end

  @tag slow: true
  @tag timeout: 360_000
  test "Performance" do
    IO.puts("Creating users...")

    users =
      0..100
      |> Enum.map(fn _ ->
        {:ok, user} = Fixtures.user()
        user
      end)

    IO.puts("Creating genres...")

    {:ok, genre_1} = Genres.create_genre(%{name: "Electronic"})
    {:ok, genre_2} = Genres.create_genre(%{name: "Classical"})
    {:ok, genre_3} = Genres.create_genre(%{name: "Pop"})
    {:ok, genre_4} = Genres.create_genre(%{name: "Metal"})

    genres = [
      genre_1,
      genre_2,
      genre_3,
      genre_4
    ]

    IO.puts("Creating albums...")

    albums =
      1..10_000
      |> Task.async_stream(fn _ ->
        genre = Enum.random(genres)

        {:ok, album} = Fixtures.album(%{genre_ids: [genre.id]})

        album
      end)
      |> Enum.map(fn {:ok, album} -> album end)

    IO.puts("Creating ratings...")

    benchmark("Finished creating ratings", fn ->
      for album <- albums, user <- users do
        if Enum.random([true, false]) do
          rating = Enum.random(0..10)
          Ratings.create_rating(user, album, %{rating: rating})
        end
      end
    end)

    IO.puts("Calculating scores...")

    benchmark("Finished calculating scores", fn ->
      Dojinlist.Ratings.Albums.calculate()
    end)

    megabytes =
      :ets.info(:albums_timed_scores, :memory) * :erlang.system_info(:wordsize) / 1_000_000

    IO.puts(
      "ets_size=#{megabytes}Mb total_albums_in_ets=#{
        Dojinlist.Ratings.Store.count(:albums_timed_scores)
      }"
    )

    benchmark("Return top 10 albums for genre", fn ->
      Dojinlist.Ratings.Albums.top_by_genre_id(:albums_timed_scores, genre_1.id, 10)
    end)
  end

  def benchmark(label, function) do
    time_in_ms =
      function
      |> :timer.tc()
      |> elem(0)
      |> Kernel./(1_000)

    IO.puts("[#{label}] - Took #{time_in_ms}ms")
  end
end
