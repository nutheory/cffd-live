defmodule CffdLiveWeb.PageController do
  use CffdLiveWeb, :controller
  alias Phoenix.LiveView

  # def index(conn, _params) do
  #   render(conn, "index.html")
  # end

  def index(conn, _) do
    LiveView.Controller.live_render(
      conn,
      CffdLiveWeb.Live.Main,
      session: %{cookies: conn.cookies}
    )
  end
end
