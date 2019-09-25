defmodule CffdLive.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias CffdLive.Accounts.{User, AccountUser}
  alias CffdLive.Assets.{Asset}

  schema "accounts" do
    # field :company_name, :string
    # field :phone, :string
    has_many :account_users, AccountUser
    has_one :logo, Asset, foreign_key: :account_id

    many_to_many(
      :users,
      User,
      join_through: AccountUser,
      on_replace: :delete
    )

    timestamps()
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [
      # :company_name,
      # :phone
    ])
  end

  def registration_changeset(account, attrs) do
    account
    |> changeset(attrs)
    |> cast_assoc(:users, with: &User.registration_changeset/2, required: true)
  end
end
