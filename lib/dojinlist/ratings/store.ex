defmodule Dojinlist.Ratings.Store do
  use GenServer

  alias :ets, as: ETS

  @stores %{
    albums: :albums_ratings_store
  }

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(_) do
    ETS.new(
      @stores[:albums],
      [:ordered_set, :named_table, :public, read_concurrency: true]
    )

    {:ok, %{}}
  end

  def top(type, limit) do
    store = @stores[type]

    {elements, _} = ETS.select_reverse(store, [{:"$1", [], [:"$1"]}], limit)

    elements
    |> Enum.reject(&(&1 == :"$end_of_table"))
  end

  def insert(type, key, value) do
    ETS.insert(@stores[type], {key, value})
  end

  def get(type, key, default \\ nil)

  def get(type, key, default) do
    case ETS.lookup(@stores[type], key) do
      [{_, value}] -> value
      _ -> default
    end
  end
end
