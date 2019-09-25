defmodule CffdLiveWeb.UserLive.Edit do
  use Phoenix.LiveView
  # alias CffdLiveWeb.Router.Helpers, as: Routes
  alias CffdLive.{Accounts}

  def render(assigns), do: CffdLiveWeb.UserView.render("edit.html", assigns)

  def mount(%{user_id: id} = _session, socket) do
    user = Accounts.get_user!(id)

    {:ok,
     assign(socket, %{
       user: user,
       changeset: Accounts.change_user(user)
     })}
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    IO.inspect(user_params, label: "user_params")
    IO.inspect(socket, label: "socks")

    changeset =
      socket.assigns.user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :update)
      |> IO.inspect()

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    IO.inspect(user_params, label: "user_params")

    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        {:stop,
         socket
         |> put_flash(:info, "User updated successfully.")
         |> redirect(to: Routes.live_path(socket, UserLive.Show, user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
