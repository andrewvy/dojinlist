defmodule Dojinlist.Repo.Migrations.AddDefaultPaymentProcessors do
  use Ecto.Migration

  alias Dojinlist.Repo
  alias Dojinlist.Schemas.PaymentProcessor

  def up do
    %PaymentProcessor{id: 1, name: "Stripe"}
    |> Repo.insert!()
  end

  def down do
    %PaymentProcessor{id: 1, name: "Stripe"}
    |> Repo.delete!()
  end
end
