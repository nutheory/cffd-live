defmodule CffdLiveWeb.MainController do
  use CffdLiveWeb, :controller
  alias Phoenix.LiveView

  def index(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _) do
    IO.inspect(current_user, label: "current_user")

    LiveView.Controller.live_render(
      conn,
      CffdLiveWeb.DashboardLive.Main,
      session: %{user_id: current_user.id}
    )
  end

  def index(%Plug.Conn{assigns: %{}} = conn, boo) do
    IO.inspect(conn, label: "NOOOOOOOOOO")

    LiveView.Controller.live_render(
      conn,
      CffdLiveWeb.PublicLive.Main,
      session: %{}
    )
  end
end
