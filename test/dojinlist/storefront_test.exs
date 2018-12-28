defmodule Dojinlist.StorefrontTest do
  use Dojinlist.DataCase

  alias Dojinlist.{
    Storefront
  }

  test "Cannot create a storefront with a blacklisted subdomain" do
    {:ok, user} = Dojinlist.Fixtures.user()

    attrs = %{
      subdomain: "api",
      creator_id: user.id
    }

    assert {:error, _} = Storefront.create_storefront(attrs)
  end
end
