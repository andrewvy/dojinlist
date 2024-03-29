defmodule Transcoder.SQS.Consumer do
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
    body = message.body

    Logger.info("message_id=#{message.message_id} received=true")

    with {:ok, json_body} <- Jason.decode(body),
         {:ok, job} <- Transcoder.Job.new(json_body) do
      case Transcoder.execute(job) do
        {:ok, job} ->
          Logger.info("message_id=#{message.message_id} elapsed_time=#{job.elapsed_time}ms")
          emit_successful_job(job)

        {:error, job, results} ->
          emit_failed_job(job, results)
          Logger.info("message_id=#{message.message_id} error='Transcoder Error'")
          :error

        _ ->
          Logger.info("message_id=#{message.message_id} error='Transcoder Error'")
          :error
      end

      {:ok, message}
    else
      _ ->
        Logger.info("message_id=#{message.message_id} error='Invalid job format.'")
        {:ok, message}
    end
  end

  defp emit_failed_job(job, results) do
    errors =
      results
      |> Enum.filter(fn {status, _} -> status === :error end)

    message = %{
      input_bucket: job.input_bucket,
      input_filepath: job.input_filepath,
      output_bucket: job.output_bucket,
      album_uuid: job.album_uuid,
      track_uuid: job.track_uuid,
      hash: job.hash,
      errors:
        Enum.map(errors, fn {_status, error_message} ->
          error_message
        end)
    }

    json = Jason.encode!(message)

    SQS.send_message("transcoder_jobs_failed", json)
    |> ExAws.request()
  end

  defp emit_successful_job(job) do
    message = %{
      input_bucket: job.input_bucket,
      input_filepath: job.input_filepath,
      output_bucket: job.output_bucket,
      elapsed_time: job.elapsed_time,
      album_uuid: job.album_uuid,
      track_uuid: job.track_uuid,
      hash: job.hash
    }

    json = Jason.encode!(message)

    SQS.send_message("transcoder_jobs_successful", json)
    |> ExAws.request()
  end
end
