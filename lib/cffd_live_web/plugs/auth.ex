defmodule CffdLive.Plugs.Auth do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller
  alias CffdLive.ErrorView

  def init(opts) do
    {opts[:app_layout], opts[:public_layout]}
  end

  def call(conn, {app_layout, public_layout}) do
    IO.inspect(get_session(conn), label: "SESSSSS")
    user_id = get_session(conn, :user_id)
    current_user = user_id && CffdLive.Accounts.get_user!(user_id)
    assign(conn, :current_user, current_user)

    if current_user do
      assign(conn, :current_user, current_user)
      |> put_layout({CffdLiveWeb.LayoutView, app_layout})
    else
      put_layout(conn, {CffdLiveWeb.LayoutView, public_layout})
    end
  end

  def logged_in_user(%{assigns: %{current_user: %{}}} = conn, _opts), do: conn

  def logged_in_user(conn, _opts) do
    conn
    |> put_flash(:error, "Please log in to access that.")
    |> redirect(to: "/login")
    |> halt()
  end

  def is_admin(%{assigns: %{current_user: %{role: 'admin'}}} = conn, _), do: conn

  def is_admin(conn, opts) do
    if opts[:pokerface] do
      conn
      |> put_status(404)
      |> render(ErrorView, :"404", message: "Not Found.")
      |> halt()
    end

    conn
    |> put_flash(:error, "Unauthorized access.")
    |> redirect(to: "/")
    |> halt()
  end

  # defp render_layout(%Plug.Conn{assigns: %{current_user: }} = conn, {app_layout, _}) do
  #   put_layout(conn, {CffdLiveWeb.LayoutView, app_layout})
  # end

  # defp render_layout(conn, {_, public_layout}) do
  #   put_layout(conn, {CffdLiveWeb.LayoutView, public_layout})
  # end
end
