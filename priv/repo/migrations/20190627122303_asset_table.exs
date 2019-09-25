defmodule CffdLive.Repo.Migrations.AssetTable do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :user_id, references(:users)
      add :account_id, references(:accounts)
      add :uploader_id, references(:users)
      add :url, :string, null: false
      add :default, :boolean, default: false
      add :meta, :map
      timestamps()
    end
  end
end
