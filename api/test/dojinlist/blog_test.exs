defmodule Dojinlist.BlogTest do
  use Dojinlist.DataCase

  alias Dojinlist.Blog

  test "Can insert blog post" do
    {:ok, user} = Dojinlist.Fixtures.user()

    assert {:ok, post} =
             Blog.create_post(%{
               user_id: user.id,
               title: "Hello World",
               slug: "hello-world",
               content: """
               Hello World! Check out this post!
               """
             })
  end

  test "Cannot insert same slug" do
    {:ok, user} = Dojinlist.Fixtures.user()

    attrs = %{
      user_id: user.id,
      title: "Hello World",
      slug: "hello-world",
      content: """
      Hello World! Check out this post!
      """
    }

    assert {:ok, post} = Blog.create_post(attrs)
    assert {:error, _} = Blog.create_post(attrs)
  end
end
