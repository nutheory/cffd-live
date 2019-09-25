defmodule CffdLive.Assets.Asset do
  use Ecto.Schema
  import Ecto.Changeset
  alias CffdLive.Accounts.{User, Account}

  schema "assets" do
    belongs_to :user, User
    belongs_to :uploader, User
    field :url, :string, null: false
    field :default, :boolean, default: false
    field :meta, :map
  end

  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [
      :url,
      :default,
      :meta
    ])
  end
end
