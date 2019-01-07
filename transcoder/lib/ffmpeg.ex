defmodule Transcoder.FFmpeg do
  @presets %{
    "mp3-v0" => %{
      ext: ".mp3",
      ffmpeg_options: ["-ac", "2", "-q", "0"]
    },
    "mp3-320" => %{
      ext: ".mp3",
      ffmpeg_options: ["-ac", "2", "-b", "320k"]
    },
    "mp3-128" => %{
      ext: ".mp3",
      ffmpeg_options: ["-ac", "2", "-b", "128k"]
    },
    "flac" => %{
      ext: ".flac",
      ffmpeg_options: ["-ac", "2"]
    }
  }

  def input_options(input_filepath) do
    [
      "-y",
      "-i",
      input_filepath
    ]
  end

  def cover_image_options(cover_image_filepath) do
    [
      "-i",
      cover_image_filepath,
      "-map",
      "0:0",
      "-map",
      "1:0",
      "-vcodec",
      "copy"
    ]
  end

  def metadata_options(job) do
    [
      "-metadata",
      "comment=#{job.comment}",
      "-metadata",
      "track=#{job.track}",
      "-metadata",
      "album_artist=#{job.album_artist}",
      "-metadata",
      "artist=#{job.artist}",
      "-metadata",
      "album=#{job.album}",
      "-metadata",
      "title=#{job.title}"
    ]
  end

  def cover_image_metadata_options() do
    [
      "-metadata:s:v",
      "title=Album cover",
      "-metadata:s:v",
      "comment=Cover (front)"
    ]
  end

  def output_options(output_filepath) do
    [
      output_filepath
    ]
  end

  def presets() do
    @presets
  end

  def transcode(job, preset, input_filepath, output_filepath, cover_image_filepath) do
    ffmpeg_options =
      ffmpeg_options(
        input_filepath,
        output_filepath,
        cover_image_filepath,
        job,
        preset
      )

    execute(ffmpeg_options)
    |> case do
      :ok ->
        # Cannot embed album art in flac with ffmpeg just yet: https://trac.ffmpeg.org/ticket/4442
        if cover_image_filepath && preset.ext == ".flac" do
          execute_metaflac(["--import-picture-from", cover_image_filepath, output_filepath])
        else
          :ok
        end

      error ->
        error
    end
  end

  def ffmpeg_options(input_filepath, output_filepath, cover_image_filepath, job, preset) do
    if cover_image_filepath && preset.ext !== ".flac" do
      input_options(input_filepath) ++
        cover_image_options(cover_image_filepath) ++
        metadata_options(job) ++
        cover_image_metadata_options() ++ preset.ffmpeg_options ++ output_options(output_filepath)
    else
      input_options(input_filepath) ++
        metadata_options(job) ++ preset.ffmpeg_options ++ output_options(output_filepath)
    end
  end

  def execute(args) do
    case System.cmd(ffmpeg_path(), args, stderr_to_stdout: true) do
      {_, 0} -> :ok
      error -> {:error, error}
    end
  end

  def execute_metaflac(args) do
    case System.cmd(
           metaflac_path(),
           args,
           stderr_to_stdout: true
         ) do
      {_, 0} -> :ok
      error -> {:error, error}
    end
  end

  def ffmpeg_path() do
    System.find_executable("ffmpeg")
  end

  def metaflac_path() do
    System.find_executable("metaflac")
  end
end
