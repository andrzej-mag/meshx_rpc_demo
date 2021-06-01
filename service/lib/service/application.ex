defmodule Service.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [Service.Meshx.Supervisor]
    opts = [strategy: :one_for_one, name: Service.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
