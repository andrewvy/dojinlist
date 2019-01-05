defmodule Transcoder.SQS.Consumer do
  use GenStage

  alias ExAws.SQS

  def start_link({queue_name, producers}, opts \\ []) do
    GenStage.start_link(__MODULE__, [queue: queue_name, producers: producers], opts)
  end

  def init(queue: queue_name, producers: producers) do
    state = %{
      queue: queue_name
    }

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
    body = message.body

    IO.puts("Got message #{message.message_id}")

    with {:ok, json_body} <- Jason.decode(body),
         {:ok, job} <- Transcoder.Job.new(json_body) do
      case Transcoder.execute(job) do
        {:ok, job} ->
          IO.puts("message_id=#{message.message_id} elapsed_time=#{job.elapsed_time}ms")
          emit_successful_job(job)

        _ ->
          IO.puts("message_id=#{message.message_id} error='Transcoder Error'")
          :error
      end

      {:ok, message}
    else
      _ ->
        IO.puts("message_id=#{message.message_id} error='Invalid job format.'")
        {:ok, message}
    end
  end

  defp emit_successful_job(job) do
    message = %{
      input_bucket: job.input_bucket,
      input_filepath: job.input_filepath,
      output_bucket: job.output_bucket,
      elapsed_time: job.elapsed_time
    }

    json = Jason.encode!(message)

    SQS.send_message("transcoder_jobs_successful", json)
    |> ExAws.request()
  end
end
