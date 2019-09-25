defmodule CffdLiveWeb.SessionController do
  use CffdLiveWeb, :controller

  alias CffdLive.Accounts

  def new(conn, _) do
    render(conn, "login.html")
  end

  def create(conn, %{
        "user" => %{"username_or_email" => username_or_email, "password" => password}
      }) do
    IO.inspect(password, label: "PASSS")

    case Accounts.authenticate(username_or_email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "You have logged in.")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Bad credentials.")
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, :not_found} ->
        IO.inspect(username_or_email, label: "username_or_email")

        conn
        |> put_flash(:error, "Not Found.")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:success, "You have logged out.")
    |> redirect(to: "/")
  end
end
