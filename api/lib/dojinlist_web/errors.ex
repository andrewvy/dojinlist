defmodule DojinlistWeb.Errors do
  def album_not_found() do
    %{
      error_code: "ALBUM_NOT_FOUND",
      error_message: "Album was not found"
    }
  end

  def checkout_failed() do
    %{
      error_code: "CHECKOUT_FAILED",
      error_message: "Could not checkout. Try again later."
    }
  end
end
