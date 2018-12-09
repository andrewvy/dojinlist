defmodule Dojinlist.Ratings.Store do
  use GenServer

  alias :ets, as: ETS

  @store :ratings_store

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(_) do
    ETS.new(@store, [:set, :named_table, :public, read_concurrency: true])

    {:ok, %{}}
  end

  def insert(type, key, value) do
    ETS.insert(@store, {[type, key], value})
  end

  def get(type, key, default \\ nil)

  def get(type, key, default) do
    case ETS.lookup(@store, [type, key]) do
      [{_, value}] -> value
      _ -> default
    end
  end
end
