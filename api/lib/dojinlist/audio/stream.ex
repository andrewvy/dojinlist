defmodule Dojinlist.Audio.Stream do
  defstruct [
    :index,
    :codec_name,
    :codec_long_name,
    :codec_type,
    :codec_time_base,
    :sample_fmt,
    :sample_rate,
    :channels,
    :bits_per_sample,
    :duration,
    :duration_ts,
    :bit_rate
  ]

  @type t :: %__MODULE__{}

  def from_map(attrs) do
    struct = struct(__MODULE__)

    Enum.reduce(Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end)
  end
end
