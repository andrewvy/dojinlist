defmodule Dojinlist.BannerAttachment do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  # use Arc.Ecto.Definition

  @acl :public_read
  @extension_whitelist ~w(.jpg .jpeg .gif .png)
  @versions [:thumb]

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@extension_whitelist, file_extension)
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 1500x500^ -gravity center -extent 1500x500 -format png", :png}
  end

  def filename(version, {file, _}) do
    file_name = Path.basename(file.file_name, Path.extname(file.file_name))

    "#{version}_#{file_name}"
  end

  def s3_object_headers(_version, {file, _scope}) do
    [content_type: MIME.from_path(file.file_name)]
  end

  def wrap_url_for_local("http" <> _url = url), do: url
  def wrap_url_for_local(nil), do: nil
  def wrap_url_for_local(url), do: DojinlistWeb.Endpoint.url() <> url

  def rewrite_upload(%Plug.Upload{filename: name} = image) do
    %Plug.Upload{
      image
      | filename: random_filename(name)
    }
  end

  def random_filename(name) do
    (:crypto.strong_rand_bytes(20) |> Base.url_encode64() |> binary_part(0, 20)) <> name
  end

  def storage_dir(_version, {_file, _scope}) do
    "uploads/banners"
  end
end
