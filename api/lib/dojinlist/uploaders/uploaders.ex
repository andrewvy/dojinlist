defmodule Dojinlist.Uploaders do
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
end
