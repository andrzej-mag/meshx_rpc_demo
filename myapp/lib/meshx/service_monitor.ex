defmodule Myapp.Meshx.ServiceMonitor do
  use GenServer

  def start_link(_args), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def get_services() do
    if is_pid(Process.whereis(__MODULE__)),
      do: GenServer.call(__MODULE__, :get_services),
      else: []
  end

  @impl true
  def init(_args) do
    Process.send_after(self(), :fetch_services, 1000)
    {:ok, []}
  end

  @impl true
  def handle_call(:get_services, _from, state), do: {:reply, state, state}

  @impl true
  def handle_info(:fetch_services, state) do
    spawn(__MODULE__, :fetch, [self()])
    Process.send_after(self(), :fetch_services, 1000)
    {:noreply, state}
  end

  def handle_info({:service_list, slist}, state) when is_list(slist) do
    if slist != state,
      do: Phoenix.PubSub.broadcast(Myapp.PubSub, "service_list", {__MODULE__, slist})

    {:noreply, slist}
  end

  def fetch(from), do: send(from, {:service_list, slist()})

  defp slist() do
    case MeshxConsul.Service.Endpoint.get("/catalog/service/myservice") do
      {:ok, services} -> Enum.map(services, fn %{"ServiceID" => id} -> id end)
      _ -> []
    end
  end
end
