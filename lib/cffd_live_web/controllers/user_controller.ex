defmodule CffdLiveWeb.UserController do
  use CffdLiveWeb, :controller
  alias Phoenix.LiveView
  import CffdLive.Plugs.Auth, only: [logged_in_user: 2, is_admin: 2]
  plug :logged_in_user when action not in [:new, :create]
  plug :verify_user when action in [:edit, :update, :delete]
  plug :is_admin when action in [:delete]

  def index(%{assigns: %{current_user: %{id: user_id}}} = conn, _) do
    IO.inspect(conn, label: "CONNNNN")

    LiveView.Controller.live_render(
      conn,
      CffdLiveWeb.UserLive.PresenceIndex,
      session: %{user_id: user_id}
    )
  end

  def new(conn, _) do
    LiveView.Controller.live_render(
      conn,
      CffdLiveWeb.UserLive.New,
      session: %{}
    )
  end

  def show(%{assigns: %{current_user: current}} = conn, _) do
    LiveView.Controller.live_render(
      conn,
      CffdLiveWeb.UserLive.Show,
      session: %{current_user: current}
    )
  end

  def edit(%{assigns: %{current_user: current}} = conn, _) do
    LiveView.Controller.live_render(
      conn,
      CffdLiveWeb.UserLive.Edit,
      session: %{current_user: current}
    )
  end

  defp verify_user(
         %{assigns: %{current_user: current_user}, params: %{"id" => id}} = conn,
         _params
       ) do
    if(String.to_integer(id) === current_user.id || current_user.is_admin === true) do
      conn
    else
      conn
      |> put_flash(:error, "Unauthorized access.")
      |> redirect(to: Routes.user_path(conn, :show, current_user))
    end
  end
end
