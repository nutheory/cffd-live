defmodule CffdLive.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]
  alias CffdLive.Repo

  alias CffdLive.Accounts.{Credential, User, Account, AccountUser}

  @topic inspect(__MODULE__)

  def authenticate(username_or_email, given_password) do
    trimmed_auth = String.trim(username_or_email)

    cred =
      if username_or_email =~ "@" do
        Repo.get_by(Credential, email: trimmed_auth) |> Repo.preload(:user)
      else
        Repo.get_by(Credential, username: trimmed_auth) |> Repo.preload(:user)
      end

    cond do
      cred && checkpw(given_password, cred.password_hash) ->
        {:ok, cred.user}

      cred ->
        {:error, :unauthorized}

      true ->
        dummy_checkpw()
        {:error, :not_found}
    end
  end

  # Account

  def get_editable_account!(user_id) do
    acc_query =
      from au in AccountUser,
        where: au.user_id == ^user_id and au.role == "owner",
        select: au.account_id

    account_id = Repo.one(acc_query)

    IO.inspect(account_id, label: "ACCCCCC")
  end

  def create_account(attrs \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:account, Account.registration_changeset(%Account{}, attrs))
    |> Ecto.Multi.run(:account_users, fn repo, %{account: account} ->
      user = repo.get_by(AccountUser, account_id: account.id, user_id: hd(account.users).id)

      repo.update(AccountUser.registration_role_changeset(user))
    end)
    |> Repo.transaction()
  end

  def change_account(account, attrs \\ %{}) do
    account
    |> Account.registration_changeset(attrs)
  end

  # User

  def list_users do
    Repo.all(from u in User, order_by: [asc: u.id]) |> Repo.preload(:credentials)
  end

  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:credentials)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.registration_changeset/2)
    |> Repo.insert()
    |> notify_subscribers([:user, :created])
  end

  def update_user(%User{} = user, attrs) do
    IO.inspect(attrs["credentials"]["0"]["password"], label: "NEW ATTRS")

    cred_changeset =
      if attrs["credentials"]["0"]["password"] === "" do
        &Credential.changeset/2
      else
        &Credential.registration_changeset/2
      end

    user
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credentials, with: cred_changeset)
    |> Repo.update()
    |> notify_subscribers([:user, :updated])
  end

  def delete_user(%User{} = user) do
    user
    |> Repo.delete()
    |> notify_subscribers([:user, :deleted])
  end

  def change_user(user, params \\ %{}) do
    user
    |> User.changeset(params)
    |> Ecto.Changeset.cast_assoc(:credentials, with: &Credential.registration_changeset/2)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(CffdLive.PubSub, @topic)
  end

  def subscribe(user_id) do
    Phoenix.PubSub.subscribe(CffdLive.PubSub, @topic <> "#{user_id}")
  end

  defp notify_subscribers({:ok, result}, event) do
    Phoenix.PubSub.broadcast(CffdLive.PubSub, @topic, {__MODULE__, event, result})

    Phoenix.PubSub.broadcast(
      CffdLive.PubSub,
      @topic <> "#{result.id}",
      {__MODULE__, event, result}
    )

    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}
end
