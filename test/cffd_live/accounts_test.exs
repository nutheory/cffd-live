defmodule CffdLive.AccountsTest do
  use CffdLive.DataCase

  alias CffdLive.Repo
  alias CffdLive.Accounts
  alias CffdLive.Accounts.{Credential, User, Account}
  import CffdLive.Factory

  describe "Account.registration/1" do
    test "account gets saved with proper attrs" do
      cred = [build(:credential)]
      user = build(:user, credentials: cred)
      account_user = build(:account_user)

      acc =
        build(:account, %{
          users: [user],
          account_users: [account_user]
        })

      {:ok, account} = Accounts.create_account(acc)

      r_acc =
        Repo.get(Account, account.account.id)
        |> Repo.preload([{:users, :credentials}, :account_users])

      assert hd(r_acc.account_users).role == "owner"
      assert length(r_acc.users) > 0
    end
  end

  describe "User.authentication/1" do
  end
end
