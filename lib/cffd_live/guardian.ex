defmodule CffdLive.Guardian do
  use Guardian, otp_app: :cffd_live
  alias CffdLive.Accounts
  alias CffdLive.Accounts.User

  def subject_for_token(%User{} = user, _claims) do
    {:ok, to_string(user.id)}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user!(id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end

  def encode_user(%User{} = user) do
    %{
      user: %{
        email: user.email,
        name: user.name,
        id: user.id,
        is_admin: user.is_admin,
        username: user.username,
        phone: user.phone,
        bio: user.bio
      }
    }
  end
end
