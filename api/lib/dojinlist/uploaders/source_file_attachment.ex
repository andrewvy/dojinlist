defmodule Dojinlist.SourceFileAttachment do
  use Arc.Definition

  @versions [:original]

  def validate({_file, _}) do
    true
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
