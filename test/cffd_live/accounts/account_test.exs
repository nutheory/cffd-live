defmodule CffdLive.Accounts.AccountTest do
  use CffdLive.DataCase, async: true
  alias CffdLive.Accounts.{Account}

  describe "account creation" do
    @valid_attrs %{
      "company_name" => "Company One",
      "users" => %{
        "0" => %{
          "credentials" => %{
            "0" => %{
              "email" => "user@example.com",
              "username" => "user",
              "password" => "letmein1",
              "password_confirmation" => "letmein1"
            }
          },
          "name" => "Derek Rush"
        }
      }
    }

    @invalid_password_attrs %{
      "company_name" => "Company One",
      "users" => %{
        "0" => %{
          "credentials" => %{
            "0" => %{
              "email" => "user@example.com",
              "username" => "user",
              "password" => "letmein2",
              "password_confirmation" => "letmein1"
            }
          },
          "name" => "Derek Rush"
        }
      }
    }

    test "validates account with single user set to owner" do
      changeset = Account.registration_changeset(%Account{}, @valid_attrs)
      assert changeset.valid?
    end

    test "invalidates account with bad creds" do
      changeset = Account.registration_changeset(%Account{}, @invalid_password_attrs)

      assert %{
               users: [
                 %{credentials: [%{password_confirmation: ["does not match confirmation"]}]}
               ]
             } = errors_on(changeset)
    end
  end
end
