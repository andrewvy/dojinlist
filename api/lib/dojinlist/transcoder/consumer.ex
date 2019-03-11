defmodule Dojinlist.Transcoder.Consumer do
  use GenStage

  alias ExAws.SQS

  require Logger

  def start_link({queue_name, producers}, opts \\ []) do
    GenStage.start_link(__MODULE__, [queue: queue_name, producers: producers], opts)
  end

  def init(queue: queue_name, producers: producers) do
    state = %{
      queue: queue_name
    }

    Logger.info("Started SQS.Consumer")

    subscriptions = Enum.map(producers, &{&1, [max_demand: 1]})

    {:consumer, state, subscribe_to: subscriptions}
  end

  def handle_events(messages, _from, state) do
    handle_messages(messages, state)

    {:noreply, [], state}
  end

  defp handle_messages(messages, state) do
    results = Enum.map(messages, &process_message/1)

    successful_messages =
      results
      |> Enum.filter(fn {status, _message} -> status == :ok end)

    state.queue
    |> SQS.delete_message_batch(Enum.map(successful_messages, &make_batch_item/1))
    |> ExAws.request()
  end

  defp make_batch_item({:ok, message}) do
    %{id: Map.get(message, :message_id), receipt_handle: Map.get(message, :receipt_handle)}
  end

  defp process_message(message) do
    {:ok, message}
  end
end