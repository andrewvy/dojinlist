defmodule Dojinlist.Ratings.Store do
  use GenServer

  alias :ets, as: ETS

  @tables [
    :albums_lifetime_scores,
    :albums_timed_scores
  ]

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(_) do
    @tables
    |> Enum.map(fn table ->
      ETS.new(
        table,
        [:ordered_set, :named_table, :public, read_concurrency: true]
      )
    end)

    send(self(), :rebuild_store)

    {:ok, %{}}
  end

  def clean() do
    @tables
    |> Enum.map(fn table ->
      ETS.delete_all_objects(table)
    end)
  end

  def top(type, limit) do
    {elements, _} = ETS.select_reverse(type, [{:"$1", [], [:"$1"]}], limit)

    elements
    |> Enum.reject(&(&1 == :"$end_of_table"))
  end

  def insert(type, key, value) do
    ETS.insert(type, {key, value})
  end

  def find(type, acc, fun) do
    :ets.safe_fixtable(type, true)

    first = :ets.last(type)

    try do
      do_find(fun, {:continue, acc}, first, type)
    after
      :ets.safe_fixtable(type, false)
    end
  end

  def do_find(fun, acc, key, type) do
    case {acc, key} do
      {{:halt, acc}, _} ->
        acc

      {{_, acc}, :"$end_of_table"} ->
        acc

      _ ->
        do_find(
          fun,
          :lists.foldl(fun, elem(acc, 1), :ets.lookup(type, key)),
          :ets.prev(type, key),
          type
        )
    end
  end

  def get(type, key, default \\ nil)

  def get(type, key, default) do
    case ETS.lookup(type, key) do
      [{_, value}] -> value
      _ -> default
    end
  end

  def count(type) do
    ETS.select_count(type, [{:"$1", [], [true]}])
  end

  def handle_info(:rebuild_store, state) do
    Dojinlist.Ratings.Albums.calculate()

    Process.send_after(self(), :rebuild_store, 1_000 * 60 * 60 * 1)

    {:noreply, state}
  end
end
