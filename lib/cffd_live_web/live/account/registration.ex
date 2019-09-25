defmodule CffdLiveWeb.AccountLive.Registration do
  use Phoenix.LiveView
  # alias CffdLiveWeb.Router.Helpers, as: Routes
  alias CffdLive.{Accounts}
  alias CffdLive.Accounts.{Account, User, Credential}

  def render(assigns), do: CffdLiveWeb.AccountView.render("registration.html", assigns)

  def mount(_session, socket) do
    {:ok,
     assign(socket, %{
       changeset: Accounts.change_account(%Account{users: [%User{credentials: [%Credential{}]}]})
     })}
  end

  def handle_event("validate", %{"account" => account_params}, socket) do
    IO.inspect(account_params, label: "account_params")
    IO.inspect(socket, label: "socks")

    changeset =
      %Account{}
      |> Accounts.change_account(account_params)
      |> Map.put(:action, :insert)
      |> IO.inspect()

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"account" => account_params}, socket) do
    IO.inspect(account_params, label: "account_params")

    case Accounts.create_account(account_params) do
      {:ok, result} ->
        IO.inspect(result, label: "RESULT")

        {:noreply,
         socket
         |> put_flash(:info, "account created")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
