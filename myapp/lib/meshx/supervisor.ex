defmodule Myapp.Meshx.Supervisor do
  require Logger
  use DynamicSupervisor

  @service_name "myservice"

  def start_link(init_arg),
    do: DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)

  @impl true
  def init(_init_arg) do
    spawn(__MODULE__, :start_mesh, [])
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_mesh() do
    case MeshxConsul.connect([@service_name]) do
      {:ok, [{:ok, address}]} ->
        DynamicSupervisor.start_child(__MODULE__, Myapp.Meshx.Worker.child_spec(address: address))

      # :ok = MeshxRpc.attach_telemetry([:myapp, Myapp.Meshx.Worker])

      err ->
        Logger.error(inspect(err))
        err
    end
  end
end
