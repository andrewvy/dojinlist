defmodule Dojinlist.ReleaseTasks do
  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :elasticsearch
  ]

  # Ecto repos to start, if any
  @repos Application.get_env(:dojinlist, :ecto_repos, [])

  # Elasticsearch clusters to start
  @clusters [Dojinlist.ElasticsearchCluster]

  # Elasticsearch indexes to build
  @indexes [:albums]

  def build_elasticsearch_indexes(_argv) do
    start_services()
    IO.puts("Building indexes...")

    Enum.each(@indexes, fn index ->
      IO.puts("Building index: #{index}")

      Elasticsearch.Index.hot_swap(Dojinlist.ElasticsearchCluster, index)
      |> IO.inspect()
    end)

    stop_services()
  end

  # Ensure that all OTP apps, repos used by your Elasticsearch store,
  # and your Elasticsearch Cluster(s) are started
  defp start_services do
    IO.puts("Starting dependencies...")
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    IO.puts("Starting repos...")
    Enum.each(@repos, & &1.start_link(pool_size: 1))

    IO.puts("Starting clusters...")
    Enum.each(@clusters, & &1.start_link())
  end

  defp stop_services do
    :init.stop()
  end
end
