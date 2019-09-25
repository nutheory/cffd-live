defmodule CffdLive.Accounts.AccountUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias CffdLive.Accounts.{User, Account}

  schema "account_users" do
    belongs_to :account, Account
    belongs_to :user, User
    field :role, :string
    field :status, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :role,
      :status
    ])
  end

  def registration_role_changeset(account_user) do
    change(account_user, role: "owner")
  end
end
