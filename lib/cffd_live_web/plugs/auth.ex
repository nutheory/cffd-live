defmodule CffdLive.Plugs.Auth do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    current_user = user_id && CffdLive.Accounts.get_user!(user_id)
    assign(conn, :current_user, current_user)
  end

  def logged_in_user(conn = %{assigns: %{current_user: %{}}}, _opts), do: conn

  def logged_in_user(conn, _opts) do
    conn
    |> put_flash(:error, "Please log in to access that.")
    |> redirect(to: "/login")
    |> halt()
  end
end
