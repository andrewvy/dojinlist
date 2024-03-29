defmodule Dojinlist.Emails do
  import Swoosh.Email

  def confirmation_email(user) do
    new()
    |> to({user.username, user.email})
    |> from({"Dojinlist", "team@dojinlist.co"})
    |> subject("Confirm your email with Dojinlist")
    |> html_body("""
      <html>
          <head></head>
          <body>
            <p>Hey #{user.username},</p>
            <p>Thanks for signing up with dojinlist.co! Please confirm your email by clicking the link below.</p>
            <a href="#{base_url() <> "/confirm/email?token=" <> user.confirmation_token}">Click here to confirm your email</a>
          </body>
      </html>
    """)
    |> text_body("""
    Thanks for signing up with dojinlist.co!

    Please confirm your email at the link: #{
      base_url() <> "/confirm/email?token=" <> user.confirmation_token
    }
    """)
  end

  defp base_url() do
    Application.get_env(:dojinlist, :web_url, "https://localhost:4001")
  end
end
