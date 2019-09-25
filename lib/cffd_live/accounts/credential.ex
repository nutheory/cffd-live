defmodule CffdLive.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Argon2
  alias CffdLive.Accounts.User

  schema "credentials" do
    field(:username, :string, unique: true)
    field(:email, :string, unique: true)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :username])
    |> validate_required([:email, :username])
    |> validate_length(:username, min: 4, max: 16)
    |> validate_format(:username, ~r/^(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$/)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/)
    |> update_change(:email, &String.downcase(&1))
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def password_changeset(credential, attrs \\ %{}) do
    credential
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_format(:password, ~r/^(?=[^\d_].*?\d)\w(\w|[!@#$%])/)
    |> validate_length(:password, min: 8, max: 32)
    |> validate_confirmation(:password)
    |> hash_password
  end

  def registration_changeset(credential, attrs \\ %{}) do
    credential
    |> changeset(attrs)
    |> password_changeset(attrs)
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset

  defp hash_password(%{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Argon2.hashpwsalt(password))
  end
end
