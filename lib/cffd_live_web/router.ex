defmodule CffdLiveWeb.Router do
  use CffdLiveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CffdLive.Plugs.Auth, app_layout: :app, public_layout: :public
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CffdLiveWeb do
    pipe_through :browser

    get "/", MainController, :index, session: [:user_id]
    # live "/", DashboardLive.Main, session: [:user_id]
    live "/account/registration", AccountLive.Registration, session: %{}
    live "/edit", UserLive.Edit, session: [:user_id]
    # get "/users/register", UserController, :new
    get "/login", SessionController, :new
    get "/logout", SessionController, :delete
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true
  end

  # scope "/users", CffdLiveWeb do
  #   pipe_through :browser

  # end

  # Other scopes may use custom stacks.
  # scope "/api", CffdLiveWeb do
  #   pipe_through :api
  # end
end
