defmodule CffdLiveWeb.DashboardLive.Main do
  use Phoenix.LiveView
  alias CffdLive.Accounts
  alias CffdLiveWeb.{DashboardView, Presence}
  alias Phoenix.Socket.Broadcast

  def mount(%{user_id: id} = _session, socket) do
    user = Accounts.get_user!(id)
    Accounts.subscribe()
    Phoenix.PubSub.subscribe(CffdLive.PubSub, "users")
    IO.inspect(user, label: "USER")
    # username =
    #   Map.get(user.credential, :username)

    Presence.track(self(), "users", Map.get(hd(user.credentials), :username), %{
      email: hd(user.credentials).email,
      name: user.name,
      id: user.id
    })

    {:ok,
     assign(socket, %{
       current_user: user,
       menu_active: false,
       results: nil,
       online_users: Presence.list("users")
     })}
  end

  def render(assigns) do
    DashboardView.render("main.html", assigns)
  end

  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, %{
      users: Accounts.list_users(),
      online_users: Presence.list("users")
    })
  end

  # defp push_results(results, socket) do
  #   IO.inspect(results, label: "RESZZZ")
  #   assign(socket, %{results: results})
  # end
end
