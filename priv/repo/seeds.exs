# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CffdLive.Repo.insert!(%CffdLive.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# {:ok, acc} =

# {:ok, _user1} =
#   CffdLive.Accounts.create_user(%{
#     role: 'admin',
#     name: "Derek Rush",
#     phone: "9492808977",
#     avatar: "https://s3-us-west-1.amazonaws.com/cffd-live/me_thumb.jpg",
#     credential: %{
#       password: "tech9ca1",
#       password_confirmation: "tech9ca1",
#       email: "derek@cffd.ink",
#       username: "nutheory"
#     },
#     bio:
#       "Since the creation of my first app in 2003, I've always been drawn to the overlap between design and development. My skills are broad: from UX to design, front-end to back-end development. I enjoy each aspect, and love building sites from start to finish & exploring new technologies."
#   })

# {:ok, _user2} =
#   CffdLive.Accounts.create_user(%{
#     is_admin: false,
#     credential: %{
#       password: "letmein1",
#       password_confirmation: "letmein1",
#       email: "derek@nutheory.com",
#       username: "fabDisaster"
#     },
#     name: "Sid Vicious",
#     avatar: "https://s3-us-west-1.amazonaws.com/cffd-live/sid_thumb.jpg",
#     phone: "9495559090"
#   })
