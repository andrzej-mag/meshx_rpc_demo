defmodule Myapp.Meshx.Worker do
  use MeshxRpc.Client,
    telemetry_prefix: [:myapp, __MODULE__],
    pool_opts: [size: 50, max_overflow: 10],
    idle_reconnect: 30_000

  def do_work(min, max), do: call(:do_work, [min, max], max + min, 10, 50)
end
