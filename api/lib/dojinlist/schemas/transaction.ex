defmodule Dojinlist.Schemas.Transaction do
  use Ecto.Schema

  import Ecto.Changeset

  alias Dojinlist.Schemas.PaymentProcessor

  schema "transactions" do
    field :transaction_id, :string

    # Amount sent to album seller.
    field :cut_total, Money.Ecto.Composite.Type

    # Amount of goods, minux tax + shipping.
    field :sub_total, Money.Ecto.Composite.Type

    # Tax total.
    field :tax_total, Money.Ecto.Composite.Type

    # Shipping total.
    field :shipping_total, Money.Ecto.Composite.Type

    # Grand total.
    field :grand_total, Money.Ecto.Composite.Type

    # Charged total.
    field :charged_total, Money.Ecto.Composite.Type

    belongs_to :payment_processor, PaymentProcessor

    timestamps(type: :utc_datetime)
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :sub_total,
      :tax_total,
      :cut_total,
      :transaction_id,
      :payment_processor_id
    ])
    |> validate_required([
      :sub_total,
      :tax_total,
      :cut_total,
      :transaction_id,
      :payment_processor_id
    ])
  end
end
