defmodule CffdLive.Repo.Migrations.AccountTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :plan, :string
      timestamps()
    end
  end
end
