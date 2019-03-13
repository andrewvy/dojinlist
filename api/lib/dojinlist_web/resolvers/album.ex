defmodule DojinlistWeb.Resolvers.Album do
  alias Dojinlist.Albums

  def all(params, _) do
    Dojinlist.Schemas.Album
    |> Albums.build_query(params)
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end

  def by_slug(%{slug: slug}, _) do
    case Albums.get_album_by_slug(slug) do
      nil ->
        # @TODO(vy): i18n
        {:error, "Could not find album with that slug"}

      album ->
        {:ok, album}
    end
  end

  def already_purchased?(album, _, %{context: %{current_user: current_user}}) do
    {:ok, Dojinlist.Payments.account_already_purchased_album?(current_user, album)}
  end

  def already_purchased?(_, _, _) do
    {:ok, false}
  end
end
