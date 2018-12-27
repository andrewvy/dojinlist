defmodule Dojinlist.Storefront do
  alias Dojinlist.Schemas.Storefront

  alias Dojinlist.Repo

  import Ecto.Query

  def create_storefront(attrs) do
    %Storefront{}
    |> Storefront.changeset(attrs)
    |> Repo.insert()
  end

  def update_storefront(storefront, attrs) do
    storefront
    |> Storefront.changeset(attrs)
    |> Repo.update()
  end

  def by_subdomain(subdomain) do
    Storefront
    |> where([s], s.subdomain == ^subdomain)
    |> Repo.one()
  end
end