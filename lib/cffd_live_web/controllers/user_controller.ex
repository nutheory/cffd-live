defmodule CffdLiveWeb.UserController do
  use CffdLiveWeb, :controller
  alias Phoenix.LiveView
  import CffdLive.Plugs.Auth, only: [logged_in_user: 2]
  plug :logged_in_user when action not in [:new, :create]

  def new(conn, _) do
    LiveView.Controller.live_render(
      conn,
      CffdLiveWeb.UserLive.New,
      session: %{}
    )
  end

  def show(conn, _) do
    user_id = get_session(conn, :user_id)

    LiveView.Controller.live_render(
      conn,
      CffdLiveWeb.UserLive.Show,
      session: %{user_id: user_id}
    )
  end
end
