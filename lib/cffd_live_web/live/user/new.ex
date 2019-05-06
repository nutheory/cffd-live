defmodule CffdLiveWeb.UserLive.New do
  use Phoenix.LiveView
  alias CffdLiveWeb.Router.Helpers, as: Routes
  alias CffdLive.{Accounts, Accounts.User}
  def render(assigns), do: CffdLiveWeb.UserView.render("new.html", assigns)

  def mount(_session, socket) do
    IO.inspect(socket, label: "SOCKET")

    {:ok,
     assign(socket, %{
       count: 0,
       changeset: Accounts.change_user(%User{})
     })}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    IO.inspect(params, label: "PARAMS")

    changeset =
      %User{}
      |> Accounts.change_user(params)
      |> Map.put(:action, :insert)
      |> IO.inspect()

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case CffdLive.Accounts.create_user(user_params) do
      {:ok, user} ->
        {:stop,
         socket
         |> put_flash(:info, "user created")
         |> redirect(to: Routes.user_path(socket, :show, user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
