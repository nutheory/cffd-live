defmodule CffdLiveWeb.UserLive.PresenceIndex do
  use Phoenix.LiveView

  alias CffdLive.Accounts
  alias CffdLiveWeb.{UserView, Presence}
  alias Phoenix.Socket.Broadcast

  def mount(%{user_id: user_id} = _session, socket) do
    user = Accounts.get_user!(user_id)
    Accounts.subscribe()
    Phoenix.PubSub.subscribe(CffdLive.PubSub, "users")

    Presence.track(self(), "users", Map.get(user.credential, :username), %{
      email: user.credential.email,
      name: user.name,
      id: user.id
    })

    {:ok,
     assign(socket, %{
       current_user: user,
       users: Accounts.list_users(),
       online_users: Presence.list("users")
     })}
  end

  def render(assigns) do
    IO.inspect(assigns, label: "ASSIGNZ")
    UserView.render("index.html", assigns)
  end

  defp fetch(socket) do
    assign(socket, %{
      users: Accounts.list_users(),
      online_users: Presence.list("users")
    })
  end

  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_info({Accounts, [:user | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_event("delete_user", id, socket) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    {:noreply, socket}
  end
end
