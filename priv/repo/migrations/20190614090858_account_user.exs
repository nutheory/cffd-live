defmodule CffdLive.Repo.Migrations.AccountUser do
  use Ecto.Migration

  def change do
    create table(:account_users) do
      add(:account_id, references(:accounts, on_delete: :delete_all), primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all), primary_key: true)
      add(:role, :string, null: false, default: "user")
      add(:status, :string, null: false, default: "active")
      timestamps()
    end

    create(index(:account_users, [:account_id]))
    create(index(:account_users, [:user_id]))

    create(
      unique_index(:account_users, [:account_id, :user_id], name: :account_id_user_id_unique_index)
    )
  end
end
