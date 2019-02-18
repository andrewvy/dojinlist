defmodule Dojinlist.StorefrontTest do
  use Dojinlist.DataCase

  alias Dojinlist.{
    Storefront
  }

  test "Cannot create a storefront with a blacklisted slug" do
    {:ok, user} = Dojinlist.Fixtures.user()

    attrs = %{
      slug: "api",
      creator_id: user.id
    }

    assert {:error, _} = Storefront.create_storefront(attrs)
  end
end
