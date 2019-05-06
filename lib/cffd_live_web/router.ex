defmodule CffdLiveWeb.Router do
  use CffdLiveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CffdLive.Plugs.Auth
    plug :put_layout, {CffdLiveWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CffdLiveWeb do
    pipe_through :browser

    # get "/", PageController, :index
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
