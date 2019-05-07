defmodule DojinlistWeb.Resolvers.Storefront do
  alias Dojinlist.Storefront

  def by_username(%{username: username}, _) do
    case Storefront.by_username(username) do
      nil ->
        # @TODO(vy): i18n
        {:error, "Could not find a storefront with that username"}

      storefront ->
        {:ok, storefront}
    end
  end
end
