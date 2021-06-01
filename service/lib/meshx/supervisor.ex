defmodule Service.Meshx.Supervisor do
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
    case MeshxConsul.start({@service_name, sname()}) do
      {:ok, id, address} ->
        :ok = MeshxRpc.attach_telemetry([:service, Service.Meshx.Worker])
        :ok = :persistent_term.put({:service, :id}, id)

        DynamicSupervisor.start_child(
          __MODULE__,
          Service.Meshx.Worker.child_spec(address: address)
        )

      err ->
        Logger.error(inspect(err))
        err
    end
  end

  defp sname(id \\ @service_name, count \\ 1) do
    sid = "#{id}-#{count}"

    case MeshxConsul.info(sid) do
      {:ok, _info} -> sname(id, count + 1)
      _ -> sid
    end
  end
end
