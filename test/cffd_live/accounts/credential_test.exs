defmodule CffdLive.Accounts.CredentialTest do
  use CffdLive.DataCase, async: true
  alias CffdLive.Accounts.Credential

  describe "credential.changeset/2" do
    @valid_attrs %{
      email: "user@example.com",
      username: "user"
    }

    test "changeset with username less than 4 characters" do
      changeset = Credential.changeset(%Credential{}, %{@valid_attrs | username: "uu"})

      assert %{username: ["should be at least 4 character(s)"]} = errors_on(changeset)
    end

    test "changeset with invalid username format" do
      changeset = Credential.changeset(%Credential{}, %{@valid_attrs | username: "u._u"})

      assert %{username: ["has invalid format"]} = errors_on(changeset)
    end

    test "changeset with valid username format" do
      changeset = Credential.changeset(%Credential{}, %{@valid_attrs | username: "545u_u"})

      assert changeset.valid?
    end

    test "changeset with invalid email format" do
      changeset =
        Credential.changeset(%Credential{}, %{
          @valid_attrs
          | email: "545u_u%-ghfh.com"
        })

      assert %{email: ["has invalid format"]} = errors_on(changeset)
    end

    test "changeset with valid email format" do
      changeset =
        Credential.changeset(%Credential{}, %{
          @valid_attrs
          | email: "545u_u@ghf-h.com"
        })

      assert changeset.valid?
    end
  end

  describe "credential.password_changeset/2" do
    @valid_attrs %{
      password: "password",
      password_confirmation: "password"
    }

    test "changeset with invalid password length" do
      changeset =
        Credential.password_changeset(%Credential{}, %{
          @valid_attrs
          | password: "P!uh1",
            password_confirmation: "P!uh1"
        })

      assert %{password: ["should be at least 8 character(s)"]} = errors_on(changeset)
    end

    test "changeset with matching password/confirmation" do
      changeset =
        Credential.password_changeset(%Credential{}, %{
          @valid_attrs
          | password: "Letme#In1",
            password_confirmation: "Letme#In1"
        })

      assert changeset.valid?
    end

    test "changeset with not matching password/confirmation" do
      changeset =
        Credential.password_changeset(%Credential{}, %{
          @valid_attrs
          | password: "Letme#In1",
            password_confirmation: "Letm#In1"
        })

      refute changeset.valid?
    end

    test "changeset with invalid password format" do
      changeset =
        Credential.password_changeset(%Credential{}, %{
          @valid_attrs
          | password: "$password#",
            password_confirmation: "$password#"
        })

      refute changeset.valid?
    end
  end
end
