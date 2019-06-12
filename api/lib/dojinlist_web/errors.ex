defmodule DojinlistWeb.Errors do
  def album_name_already_exists() do
    %{
      error_code: "ALBUM_NAME_ALREADY_EXISTS",
      error_message: "Album name already exists. Please try again with a new name."
    }
  end

  def create_album_failed() do
    %{
      error_code: "CREATE_ALBUM_FAILED",
      error_message: "Album was not able to be created. Please try again."
    }
  end

  def update_album_failed() do
    %{
      error_code: "UPDATE_ALBUM_FAILED",
      error_message: "Album was not able to be updated. Please try again."
    }
  end

  def delete_album_failed() do
    %{
      error_code: "DELETE_ALBUM_FAILED",
      error_message: "Album was not able to be deleted. Please try again."
    }
  end

  def publish_album_failed() do
    %{
      error_code: "PUBLISH_ALBUM_FAILED",
      error_message: "Album was not able to be published. Please try again."
    }
  end

  def create_track_failed() do
    %{
      error_code: "CREATE_TRACK_FAILED",
      error_message: "Track was not able to be created. Please try again."
    }
  end

  def update_track_failed() do
    %{
      error_code: "UPDATE_TRACK_FAILED",
      error_message: "Track was not able to be updated. Please try again."
    }
  end

  def track_audio_unsupported() do
    %{
      error_code: "TRACK_AUDIO_UNSUPPORTED",
      error_message:
        "Track audio must be a .wav/.aiff/.flac file with at least 44.1KHz sample rate"
    }
  end

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
