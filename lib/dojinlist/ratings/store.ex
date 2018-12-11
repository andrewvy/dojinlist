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

  def get(type, key, default \\ nil)

  def get(type, key, default) do
    case ETS.lookup(type, key) do
      [{_, value}] -> value
      _ -> default
    end
  end
end
