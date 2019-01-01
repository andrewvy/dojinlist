defmodule Dojinlist.Subdomain do
  @blacklist File.read!("priv/subdomain_blacklist.txt")
             |> String.split("\n")
             |> Enum.map(&String.trim/1)

  def blacklisted?(subdomain) do
    Enum.member?(@blacklist, subdomain)
  end
end
