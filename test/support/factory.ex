defmodule CffdLive.Factory do
  use ExMachina.Ecto, repo: CffdLive.Repo
  alias CffdLive.Accounts.{Account, User, Credential, AccountUser}
  # role: sequence(:role, ["admin", "user", "other"]),

  def account_factory do
    %{
      company_name: "company",
      users: build_list(1, :user)
    }
  end

  def account_user_factory do
    %{
      role: "user",
      status: "active"
    }
  end

  def user_factory do
    %{
      name: "Jane Smith",
      credentials: [build(:credential)]
    }
  end

  def credential_factory do
    pass = "letmein1"

    %{
      username: sequence(:username, &"username#{&1}"),
      email: sequence(:email, &"email#{&1}@example.com"),
      password: pass,
      password_confirmation: pass
    }
  end
end
