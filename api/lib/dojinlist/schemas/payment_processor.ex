defmodule Dojinlist.Schemas.PaymentProcessor do
  use Ecto.Schema

  import Ecto.Changeset

  schema "payment_processors" do
    field :name, :string
  end

  def changeset(payment_processor, attrs) do
    payment_processor
    |> cast(attrs, [
      :name
    ])
  end

  def stripe() do
    %__MODULE__{
      id: 1,
      name: "Stripe"
    }
  end
end
