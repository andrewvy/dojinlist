defmodule Dojinlist.ElasticsearchStore do
  @behaviour Elasticsearch.Store

  import Ecto.Query

  alias Dojinlist.Repo

  @impl true
  def stream(Dojinlist.Schemas.Album) do
    Dojinlist.Schemas.Album
    |> preload([u], [:artists, :genres])
    |> cursor_stream()
  end

  def stream(schema) do
    Repo.stream(schema)
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

  @impl true
  def transaction(fun) do
    {:ok, result} = Repo.transaction(fun, timeout: :infinity)
    result
  end
end
