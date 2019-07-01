defmodule PhoenixDockerWeb.ClockLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
      Time: <b><%= @time %></b>
    </div>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(1, self(), :tick)

    {:ok, put_time(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_time(socket)}
  end

  defp put_time(socket) do
    assign(socket, :time, NaiveDateTime.utc_now())
  end
end
