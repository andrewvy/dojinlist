defmodule DojinlistWeb.Mutations.Me do
  use Absinthe.Schema.Notation

  object :me_mutations do
    field :upload_avatar, type: :user do
      arg(:avatar, non_null(:upload))

      middleware(DojinlistWeb.Middlewares.Authorization)

      resolve(&upload_avatar/2)
    end
  end

  def upload_avatar(attrs, %{context: %{current_user: current_user}}) do
    with {:ok, avatar} <- handle_avatar(attrs[:avatar]),
         attrs = %{avatar: avatar},
         {:ok, user} <- Dojinlist.Accounts.update(current_user, attrs) do
      {:ok, user}
    else
      {:error, _} = error -> error
    end
  end

  def handle_avatar(avatar) do
    Dojinlist.ImageAttachment.rewrite_upload(avatar)
    |> Dojinlist.ImageAttachment.store()
  end
end
