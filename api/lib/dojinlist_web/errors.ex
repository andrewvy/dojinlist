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

  def checkout_already_purchased() do
    %{
      error_code: "CHECKOUT_ALREADY_PURCHASED",
      error_message: "Album was already purchased."
    }
  end

  def checkout_not_configured() do
    %{
      error_code: "CHECKOUT_NOT_CONFIGURED",
      error_message: "Album is not configured to be purchased."
    }
  end
end
