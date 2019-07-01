defmodule PhoenixDockerWeb.TestLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
      <h2 phx-click="boom">Counter: <b><%= @counter %></b></h2>
      <a class="button" phx-click="inc">+</a>
      <br>
      <a class="button" phx-click="dec">-</a>
      <br>
      <input type="text" name="min" phx-blur="set_min" placeholder="MIN" value="<%= @min %>">
      <input type="text" name="max" phx-blur="set_max" placeholder="MAX" value="<%= @max %>">
      <a class="button" phx-click="randomize">Random</a>
    </div>
    """
  end

  def mount(_session, socket) do
    socket = assign(socket, counter: 0, min: 0, max: 100)
    {:ok, socket}
  end

  def handle_event("inc", _, socket) do
    counter = socket.assigns.counter + 1
    {:noreply, assign(socket, :counter, counter)}
  end

  def handle_event("dec", _, socket) do
    counter = socket.assigns.counter - 1
    {:noreply, assign(socket, :counter, counter)}
  end

  def handle_event("set_max", val, socket) do
    {max, _} = Integer.parse(val)
    {:noreply, assign(socket, :max, max)}
  end

  def handle_event("set_min", val, socket) do
    {min, _} = Integer.parse(val)
    {:noreply, assign(socket, :min, min)}
  end

  def handle_event("randomize", _, socket) do
    val = socket.assigns.min..socket.assigns.max |> Enum.random()
    {:noreply, assign(socket, :counter, val)}
  end
end
