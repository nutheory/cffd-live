defmodule CffdLive.Accounts.Session do
  alias CffdLive.Repo
  alias CffdLive.Accounts.User

  def authenticate(args) do
    user = Repo.get_by(User, username: String.downcase(args.username))

    case check_password(user, args) do
      true -> {:ok, user}
      _ -> {:error, "Invalid login."}
    end
  end

  defp check_password(user, args) do
    case user do
      nil -> Comeonin.Argon2.dummy_checkpw()
      _ -> Comeonin.Argon2.checkpw(args.password, user.password_hash)
    end
  end
end
