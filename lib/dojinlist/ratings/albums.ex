defmodule Dojinlist.Ratings.Albums do
  import Ecto.Query

  alias Dojinlist.Repo
  alias Dojinlist.Ratings.Store

  @beta_prior %{
    # 0
    0 => 2,
    # 1
    1 => 2,
    # 2
    2 => 2,
    # 3
    3 => 2,
    # 4
    4 => 2,
    # 5
    5 => 2,
    # 6
    6 => 2,
    # 7
    7 => 2,
    # 8
    8 => 2,
    # 9
    9 => 2,
    # 10
    10 => 2
  }

  @weights %{
    0 => -30,
    1 => -10,
    2 => 1,
    3 => 2,
    4 => 3,
    5 => 4,
    6 => 5,
    7 => 6,
    8 => 10,
    9 => 15,
    10 => 25
  }

  def calculate() do
    Dojinlist.Schemas.Album
    |> preload([:ratings, :genres, :artists])
    |> cursor_stream()
    |> Enum.map(fn album ->
      ratings =
        album.ratings
        |> Enum.reduce(%{}, fn rating, acc ->
          if rating.rating do
            Map.update(acc, rating.rating, 1, fn count -> count + 1 end)
          else
            acc
          end
        end)
        |> Map.merge(@beta_prior, fn _key, value_1, value_2 ->
          value_1 + value_2
        end)

      sum_of_weighted_prior =
        0..10
        |> Enum.reduce(0, fn vote_type, sum ->
          sum + ratings[vote_type] * @weights[vote_type]
        end)

      number_of_votes =
        ratings
        |> Enum.reduce(0, fn {_, value}, acc ->
          value + acc
        end)

      lifetime_score = sum_of_weighted_prior / number_of_votes

      rate = 1 / 360

      timed_score =
        album.ratings
        |> Enum.reject(&(&1.rating == nil || &1.rating == 0))
        |> Enum.reduce(1, fn rating, acc ->
          inserted_at = rating.inserted_at
          t = DateTime.to_unix(inserted_at, :second)

          normalized_rating = rating.rating / 10.0

          u = :erlang.max(acc + normalized_rating, rate * t + normalized_rating)
          v = :erlang.min(acc + normalized_rating, rate * t + normalized_rating)

          acc + u + :math.log(1 + :math.exp(v - u))
        end)

      genre_ids =
        album.genres
        |> Enum.map(& &1.id)

      artist_ids =
        album.artists
        |> Enum.map(& &1.id)

      Store.insert(
        :albums_lifetime_scores,
        album.id,
        {lifetime_score, genre_ids, artist_ids, [album.event_id]}
      )

      Store.insert(
        :albums_timed_scores,
        album.id,
        {timed_score, genre_ids, artist_ids, [album.event_id]}
      )

      {lifetime_score, timed_score}
    end)
  end

  def top_by_genre_id(type, genre_id, count) do
    {_total, _max, result} =
      Dojinlist.Ratings.Store.find(type, {0, count, []}, fn {_, {_, genres, _, _}} = element,
                                                            {current_count, max, list} = acc ->
        if Enum.any?(genres, &(&1 == genre_id)) do
          if current_count + 1 == max do
            {:halt, {max, max, [element | list]}}
          else
            {:cont, {current_count + 1, max, [element | list]}}
          end
        else
          {:cont, acc}
        end
      end)

    result
    |> Enum.reverse()
  end

  def top_by_artist_id(type, artist_id, count) do
    {_total, _max, result} =
      Dojinlist.Ratings.Store.find(type, {0, count, []}, fn {_, {_, _, artists, _}} = element,
                                                            {current_count, max, list} = acc ->
        if Enum.any?(artists, &(&1 == artist_id)) do
          if current_count + 1 == max do
            {:halt, {max, max, [element | list]}}
          else
            {:cont, {current_count + 1, max, [element | list]}}
          end
        else
          {:cont, acc}
        end
      end)

    result
    |> Enum.reverse()
  end

  def top_by_event_id(type, event_id, count) do
    {_total, _max, result} =
      Dojinlist.Ratings.Store.find(type, {0, count, []}, fn {_, {_, _, _, events}} = element,
                                                            {current_count, max, list} = acc ->
        if Enum.any?(events, &(&1 == event_id)) do
          if current_count + 1 == max do
            {:halt, {max, max, [element | list]}}
          else
            {:cont, {current_count + 1, max, [element | list]}}
          end
        else
          {:cont, acc}
        end
      end)

    result
    |> Enum.reverse()
  end

  def cursor_stream(query) do
    Stream.resource(
      fn ->
        %{
          query: from(o in query, order_by: [asc: o.inserted_at, asc: o.id]),
          should_halt: false,
          cursor: nil
        }
      end,
      fn acc ->
        if acc.should_halt do
          {:halt, acc}
        else
          %{
            entries: entries,
            metadata: metadata
          } =
            if acc.cursor do
              Repo.paginate(acc.query,
                after: acc.cursor,
                cursor_fields: [:inserted_at, :id],
                limit: 50
              )
            else
              Repo.paginate(acc.query, cursor_fields: [:inserted_at, :id], limit: 50)
            end

          if metadata.after do
            {entries, %{acc | cursor: metadata.after}}
          else
            {entries, %{acc | should_halt: true}}
          end
        end
      end,
      fn _ ->
        nil
      end
    )
  end
end
