defmodule CffdLive.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    field(:phone, :string)
    field(:bio, :string)
    has_one(:credential, CffdLive.Accounts.Credential)
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
  end
end
