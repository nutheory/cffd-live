defmodule CffdLive.Repo.Migrations.UserTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :phone, :string
      add :bio, :text
      timestamps()
    end

    create table(:credentials) do
      add(:username, :string, null: false)
      add(:site, :string)
      add(:token, :string)
      add(:email, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:user_id, references(:users), null: false)
      timestamps()
    end

    create unique_index(:credentials, [:email, :username])
  end
end
