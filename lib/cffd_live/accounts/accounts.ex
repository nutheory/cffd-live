defmodule CffdLive.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]
  alias CffdLive.Repo

  alias CffdLive.Accounts.{Credential, User}

  def authenticate(username_or_email, given_password) do
    cred =
      if username_or_email =~ "@" do
        Repo.get_by(Credential, email: username_or_email) |> Repo.preload(:user)
      else
        Repo.get_by(Credential, username: username_or_email) |> Repo.preload(:user)
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

  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:credential)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.registration_changeset/2)
    |> Repo.insert()

    # |> notify_subscribers([:user, :created])
  end

  def update_user(%User{} = user, attrs) do
    cred_changeset =
      if attrs[:credential][:password] === "" do
        &Credential.changeset/2
      else
        &Credential.registration_changeset/2
      end

    user
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: cred_changeset)
    |> Repo.update()
  end

  def change_user(user, params \\ %{}) do
    user
    |> User.changeset(params)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.registration_changeset/2)
  end
end
