defmodule CffdLiveWeb.PublicLive.Main do
  use Phoenix.LiveView
  alias CffdLiveWeb.{PublicView}

  def mount() do
  end

  def render(assigns) do
    PublicView.render("main.html", assigns)
  end
end
