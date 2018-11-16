defmodule Dojinlist.ImageAttachment do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  # use Arc.Ecto.Definition

  @acl :public_read
  @extension_whitelist ~w(.jpg .jpeg .gif .png)
  @versions [:original, :thumb]

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@extension_whitelist, file_extension)
  end

  def transform(:original, _) do
    {:convert, "-strip -format png", :png}
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 100x100^ -gravity center -extent 100x100 -format png", :png}
  end

  def filename(version, {file, _}) do
    file_name = Path.basename(file.file_name, Path.extname(file.file_name))

    "#{version}_#{file_name}"
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

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

  # Whitelist file extensions:
  # def validate({file, _}) do
  #   ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  # end

  # Define a thumbnail transformation:
  # def transform(:thumb, _) do
  #   {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  # end

  # Override the persisted filenames:
  # def filename(version, _) do
  #   version
  # end

  # Override the storage directory:
  # def storage_dir(version, {file, scope}) do
  #   "uploads/user/avatars/#{scope.id}"
  # end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end
