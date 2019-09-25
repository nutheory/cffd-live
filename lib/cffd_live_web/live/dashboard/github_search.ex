defmodule CffdLiveWeb.DashboardLive.GithubSearch do
  use Phoenix.LiveView
  alias CffdLive.Search
  alias CffdLiveWeb.{DashboardView}

  def mount(_session, socket) do
    producer_pid = setup_genstage(socket)

    {:ok,
     assign(socket, %{
       results: nil,
       producer_pid: producer_pid
     })}
  end

  def render(assigns) do
    DashboardView.render("github.html", assigns)
  end

  def handle_event("search_change", params, socket) do
    results = CffdLive.Search.run(params).body
    {:noreply, assign(socket, %{results: results})}
  end

  defp setup_genstage(socket) do
    {:ok, producer} = Search.Query.start_link(socket)
    {:ok, producer_consumer} = Search.QueryLimiter.start_link(:ok)
    {:ok, consumer} = Search.QueryRunner.start_link(:ok)
    GenStage.sync_subscribe(producer_consumer, to: producer)
    GenStage.sync_subscribe(consumer, to: producer_consumer)
    {:ok, producer}
  end
end
