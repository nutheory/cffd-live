defmodule CffdLiveWeb.DashboardLive.Header do
  use Phoenix.LiveView
  # alias CffdLive.Accounts
  alias CffdLiveWeb.{DashboardView}

  def mount(%{user: user}, socket) do
    # user = Accounts.get_user!(session.user_id)
    {:ok, assign(socket, %{current_user: user, menu_active: false})}
  end

  def render(assigns) do
    DashboardView.render("header.html", assigns)
  end

  def handle_event("toggle-menu", _, socket) do
    IO.inspect(:menu_active, label: "BLUR")

    {:noreply,
     update(socket, :menu_active, fn
       false -> true
       true -> false
     end)}
  end

  def handle_event("edit-user", _, socket) do
    # {:stop,
    #  socket
    #  |> redirect(to: "/logout")}
  end

  def handle_event("logout", _, socket) do
    {:stop,
     socket
     |> redirect(to: "/logout")}
  end
end
