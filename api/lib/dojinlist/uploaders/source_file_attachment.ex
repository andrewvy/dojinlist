defmodule Dojinlist.SourceFileAttachment do
  alias Dojinlist.Audio

  use Arc.Definition

  @extension_whitelist ~w(.wav .aiff .flac)
  @versions [:original]

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()

    Enum.member?(@extension_whitelist, file_extension)
  end

  def filename(version, {file, _}) do
    file_name = Path.basename(file.file_name, Path.extname(file.file_name))

    "#{version}_#{file_name}"
  end

  def s3_object_headers(_version, {file, _scope}) do
    [content_type: MIME.from_path(file.file_name)]
  end

  def bucket, do: "dojinlist-raw-media"
end
