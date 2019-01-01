defmodule DojinlistWeb.Resolvers.Storefront do
  alias Dojinlist.Storefront

  def by_subdomain(%{subdomain: subdomain}, _) do
    case Storefront.by_subdomain(subdomain) do
      nil ->
        # @TODO(vy): i18n
        {:error, "Could not find a storefront with that subdomain"}

      storefront ->
        {:ok, storefront}
    end
  end
end
