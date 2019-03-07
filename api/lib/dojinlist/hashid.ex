defmodule Dojinlist.Hashid do
  def encode(id) do
    new()
    |> Hashids.encode(id)
  end

  def decode(hashid) do
    new()
    |> Hashids.decode(hashid)
  end

  defp new() do
    Hashids.new(
      salt: "dojinlist api",
      min_len: 6
    )
  end
end
