defmodule Dojinlist.Schemas.Transaction do
  use Ecto.Schema

  import Ecto.Changeset

  alias Dojinlist.Schemas.PaymentProcessor

  schema "transactions" do
    field :transaction_id, :string

    field :sub_total, Money.Ecto.Composite.Type
    field :tax_total, Money.Ecto.Composite.Type
    field :cut_total, Money.Ecto.Composite.Type

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
