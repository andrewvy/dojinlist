defmodule DojinlistWeb.Middlewares.StorefrontAuthorized do
  @behaviour Absinthe.Middleware

  alias Dojinlist.Repo
  alias Dojinlist.Schemas.{Album, Track, Storefront}

  import Ecto.Query

  def call(resolution = %{context: %{current_user: current_user}}, album_id: :album) do
    album_id = Map.get(resolution.arguments, :album_id)
    current_user_id = current_user.id

    storefront =
      Album
      |> where([a], a.id == ^album_id)
      |> join(:inner, [a], s in assoc(a, :storefront))
      |> where([a, s], s.creator_id == ^current_user_id)
      |> select([a, s], s)
      |> Repo.one()

    if storefront do
      resolution
    else
      resolution
      |> Absinthe.Resolution.put_result(
        {:error,
         %{
           code: :does_not_have_permission,
           error: "You don't have permission for this type.",
           message: "You don't have permission for this type."
         }}
      )
    end
  end

  def call(resolution = %{context: %{current_user: current_user}}, track_id: :track) do
    track_id = Map.get(resolution.arguments, :track_id)
    current_user_id = current_user.id

    storefront =
      Track
      |> where([t], t.id == ^track_id)
      |> join(:inner, [t], a in assoc(t, :album))
      |> join(:inner, [t, a], s in assoc(a, :storefront))
      |> where([t, a, s], s.creator_id == ^current_user_id)
      |> select([t, a, s], s)
      |> Repo.one()

    if storefront do
      resolution
    else
      resolution
      |> Absinthe.Resolution.put_result(
        {:error,
         %{
           code: :does_not_have_permission,
           error: "You don't have permission for this type.",
           message: "You don't have permission for this type."
         }}
      )
    end
  end

  def call(resolution = %{context: %{current_user: current_user} = context},
        storefront_id: :storefront
      ) do
    storefront_id = Map.get(resolution.arguments, :storefront_id)
    current_user_id = current_user.id

    storefront =
      Storefront
      |> where([s], s.id == ^storefront_id)
      |> where([s], s.creator_id == ^current_user_id)
      |> select([s], s)
      |> Repo.one()

    if storefront do
      resolution
      |> Absinthe.Plug.put_options(context: Map.put(context, :storefront, storefront))
    else
      resolution
      |> Absinthe.Resolution.put_result(
        {:error,
         %{
           code: :does_not_have_permission,
           error: "You don't have permission for this type.",
           message: "You don't have permission for this type."
         }}
      )
    end
  end
end
