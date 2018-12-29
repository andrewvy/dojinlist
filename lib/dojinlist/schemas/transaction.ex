defmodule Dojinlist.Schemas.Transaction do
  use Ecto.Schema

  import Ecto.Changeset

  alias Dojinlist.Schemas.PaymentProcessor

  schema "transactions" do
    field :amount, :integer
    field :transaction_id, :string

    belongs_to :payment_processor, PaymentProcessor

    timestamps(type: :utc_datetime)
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :amount,
      :transaction_id,
      :payment_processor_id
    ])
    |> validate_required([
      :amount,
      :transaction_id,
      :payment_processor_id
    ])
  end
end
