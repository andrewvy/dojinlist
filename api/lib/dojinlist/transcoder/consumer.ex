defmodule Dojinlist.Transcoder.Consumer do
  use GenStage

  alias ExAws.SQS

  alias Dojinlist.{
    Hashid,
    Tracks,
    Transcoder
  }

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

  def process_message(message) do
    body = message.body

    case Jason.decode(body) do
      {:ok, json_body} ->
        process_payload(json_body)

      _ ->
        Logger.info("message_id=#{message.message_id} error='Invalid job format.'")
        {:ok, message}
    end
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

  defp process_payload(%{"errors" => _} = payload) do
    payload
    |> get_track_from_payload()
    |> Transcoder.mark_track_as_failed(payload)
  end

  defp process_payload(payload) do
    payload
    |> get_track_from_payload()
    |> Transcoder.mark_track_as_completed(payload)
  end

  defp get_track_from_payload(payload) do
    {:ok, [id]} =
      payload["track_uuid"]
      |> Hashid.decode()

    id
    |> Tracks.get_by_id()
  end
end
