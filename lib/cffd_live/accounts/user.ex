defmodule CffdLive.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias CffdLive.Accounts.{Credential, AccountUser, Account}
  alias CffdLive.Assets.{Asset}

  schema "users" do
    field :name, :string
    field :phone, :string
    field :bio, :string
    has_one :avatar, Asset, foreign_key: :user_id
    has_many :uploads, Asset, foreign_key: :uploader_id
    has_many :account_users, AccountUser, foreign_key: :user_id
    has_many :credentials, Credential

    many_to_many(
      :accounts,
      Account,
      join_through: AccountUser,
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :bio,
      :phone
    ])
    |> validate_required([:name])
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast_assoc(:credentials, with: &Credential.registration_changeset/2, required: true)
  end
end
