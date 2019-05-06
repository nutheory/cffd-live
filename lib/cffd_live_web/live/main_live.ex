defmodule CffdLiveWeb.Live.Main do
  use Phoenix.LiveView
  # use CffdLiveWeb.Live.Config

  # alias CffdLiveWeb.Live.{Blocks, Engine}

  def render(assigns), do: CffdLiveWeb.MainView.render("index.html", assigns)

  def mount(_session, socket) do
    {:ok, assign(socket, keystat: "No Key")}
  end

  def handle_event("keydown", key, socket) do
    {:noreply, assign(socket, keystat: "#{key} Down")}
  end

  def handle_event("keyup", key, socket) do
    {:noreply, assign(socket, keystat: "No Key")}
  end

  # defp on_stop_input(socket, _), do: socket
end
