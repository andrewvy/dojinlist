defmodule DojinlistWeb.Mutations.Event do
  use Absinthe.Schema.Notation

  object :event_mutations do
    field :create_event, type: :event do
      arg(:name, non_null(:string))
      arg(:start_date, :date)
      arg(:end_date, :date)

      middleware(Dojinlist.Middlewares.Authorization)

      resolve(&create_event/2)
    end
  end

  def create_event(attrs, _) do
    case Dojinlist.Events.create_event(attrs) do
      {:ok, event} ->
        {:ok, event}

      {:error, _changeset} ->
        # @TODO(vy): i18n
        {:error, "Could not create event"}
    end
  end
end
