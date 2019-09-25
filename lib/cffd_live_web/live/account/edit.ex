defmodule CffdLiveWeb.AccountLive.Edit do
  use Phoenix.LiveView
  # alias CffdLiveWeb.Router.Helpers, as: Routes
  alias CffdLive.{Accounts}

  def render(assigns), do: CffdLiveWeb.AccountView.render("edit.html", assigns)

  def mount(%{user_id: id} = _session, socket) do
    user = Accounts.get_user!(id)

    {:ok,
     assign(socket, %{
       changeset: Accounts.change_account(user)
     })}
  end
end
