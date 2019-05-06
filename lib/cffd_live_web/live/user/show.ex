defmodule CffdLiveWeb.UserLive.Show do
  use Phoenix.LiveView
  alias CffdLiveWeb.Router.Helpers, as: Routes
  alias CffdLive.{Accounts, Accounts.User}
  def render(assigns), do: CffdLiveWeb.UserView.render("show.html", assigns)

  def mount() do
  end
end
