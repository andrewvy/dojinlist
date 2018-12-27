defmodule DojinlistWeb.Mutations.Storefront do
  use Absinthe.Schema.Notation

  object :storefront_mutations do
    field :create_storefront, type: :storefront do
      arg(:storefront, non_null(:storefront_input))

      middleware(DojinlistWeb.Middlewares.Authorization)

      resolve(&create_storefront/2)
    end
  end

  def create_storefront(%{storefront: storefront_attrs}, %{context: %{current_user: user}}) do
    merged_attrs =
      %{
        creator_id: user.id
      }
      |> Map.merge(storefront_attrs)

    case Dojinlist.Storefront.create_storefront(merged_attrs) do
      {:ok, storefront} -> {:ok, storefront}
      # @TODO(vy): i18n
      {:error, _} -> {:error, "Could not create storefront"}
    end
  end
end
