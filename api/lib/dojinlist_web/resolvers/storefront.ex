defmodule DojinlistWeb.Resolvers.Storefront do
  alias Dojinlist.Storefront

  def by_slug(%{slug: slug}, _) do
    case Storefront.by_slug(slug) do
      nil ->
        # @TODO(vy): i18n
        {:error, "Could not find a storefront with that slug"}

      storefront ->
        {:ok, storefront}
    end
  end
end
