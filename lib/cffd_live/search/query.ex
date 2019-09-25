defmodule CffdLive.Search.Query do
  use GenStage

  def start_link(socket), do: GenStage.start_link(__MODULE__, socket)

  def update(pid, event), do: GenStage.cast(pid, {:notify, event})

  def init(socket), do: {:producer, socket, buffer_size: 1}

  def handle_cast({:notify, event}, socket) do
    {:noreply, [{socket, event}], socket}
  end

  def handle_demand(_demand, state), do: {:noreply, [], state}
end
