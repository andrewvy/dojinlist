defmodule Dojinlist.Source do
  def data() do
    Dataloader.Ecto.new(Dojinlist.Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end
