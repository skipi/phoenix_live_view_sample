defmodule PhoenixDockerWeb.ProcessLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
      Set update speed <input class="inline" type="number" min="100" max="10000" value="<%= @tick %>" name="tick" phx-blur="update_tick">
      <br>

      Processes: <b><%= length(@processes) %></b> - total memory <b><%= total_mem(@processes) %>kB</b>
      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Memory</th>
            <th>Total heap size</th>
            <th>Heap size</th>
            <th>Stack size</th>
            <th>Reductions</th>
          </tr>
        </thead>
        <%= for process <- @processes do %>
          <tr>
            <td><%= process.name %></td>
            <td><%= process.memory %></td>
            <td><%= process.total_heap_size %></td>
            <td><%= process.heap_size %></td>
            <td><%= process.stack_size %></td>
            <td><%= process.reductions %></td>
          </tr>
        <% end %>
      </table>
    </div>
    """
  end

  def mount(_session, socket) do
    socket = set_tick(socket, 1000)
    socket = get_process_info(socket)
    socket = set_ref(socket)
    {:ok, socket}
  end

  def handle_info(:fetch_processes, socket) do
    {:noreply, get_process_info(socket)}
  end

  def handle_event("update_tick", tick, socket) do
    {tick, _} = Integer.parse(tick)

    socket =
      socket
      |> set_tick(tick)
      |> set_ref

    {:noreply, socket}
  end

  defp get_process_info(socket) do
    processes =
      Process.list()
      |> Enum.map(fn pid ->
        {:memory, memory} = :erlang.process_info(pid, :memory)
        {Process.info(pid), memory}
      end)
      |> Enum.map(fn {process_info, memory} ->
        %{
          name: Keyword.get(process_info, :registered_name, "-"),
          memory: memory,
          heap_size: Keyword.get(process_info, :heap_size),
          total_heap_size: Keyword.get(process_info, :total_heap_size),
          stack_size: Keyword.get(process_info, :stack_size),
          reductions: Keyword.get(process_info, :reductions)
        }
      end)
      |> Enum.sort_by(& &1.memory)
      |> Enum.reverse()

    assign(socket, :processes, processes)
  end

  defp total_mem(processes) do
    total_mem =
      processes
      |> Enum.map(& &1.memory)
      |> Enum.sum()

    (total_mem / 1024)
    |> :erlang.float_to_binary(decimals: 2)
  end

  defp set_tick(socket, tick) do
    assign(socket, :tick, tick)
  end

  defp set_ref(socket) do
    tick = Map.get(socket.assigns, :tick)

    ref =
      Map.get(socket.assigns, :ref)
      |> case do
        nil ->
          {:ok, ref} = :timer.send_interval(tick, self(), :fetch_processes)
          ref

        ref ->
          :timer.cancel(ref)
          {:ok, ref} = :timer.send_interval(tick, self(), :fetch_processes)
          ref
      end

    assign(socket, :ref, ref)
  end
end
