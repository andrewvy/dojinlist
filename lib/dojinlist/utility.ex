defmodule Dojinlist.Utility do
  def parse_integer(integer) when is_binary(integer) do
    {number, _} = Integer.parse(integer)
    number
  end

  def parse_integer(integer) when is_number(integer) do
    integer
  end
end
