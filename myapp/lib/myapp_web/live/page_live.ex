defmodule MyappWeb.PageLive do
  @moduledoc """
  Programming patterns presented in this module are for service mesh capabilities presentation only and should not be used in production systems.
  In most basic case, instead of using `spawn/3` to execute remote calls, one should consider using `Task` module.
  """

  use MyappWeb, :live_view
  alias Myapp.Meshx.ServiceMonitor

  @form_count 10
  @form_tmin 1
  @form_tmax 5_000

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Myapp.PubSub, "service_list")

    {:ok,
     assign(socket,
       responses: [],
       service_list: ServiceMonitor.get_services(),
       form_count: @form_count,
       form_tmin: @form_tmin,
       form_tmax: @form_tmax
     )}
  end

  @impl true
  def handle_info({Myapp.Meshx.ServiceMonitor, service_list}, socket),
    do: {:noreply, assign(socket, %{service_list: service_list})}

  @impl true
  def handle_info({status, result, in_pid}, socket) when status in [:rpc_ok, :rpc_error] do
    response =
      Enum.map(socket.assigns.responses, fn {pid, id} ->
        if in_pid == pid, do: {pid, result}, else: {pid, id}
      end)

    {:noreply, assign(socket, responses: response)}
  end

  @impl true
  def handle_event("spawn", %{"count" => count, "max" => max, "min" => min}, socket) do
    count = String.to_integer(count)
    min = String.to_integer(min)
    max = String.to_integer(max)

    responses =
      for _ <- 1..count do
        spawn(__MODULE__, :do_work, [self(), min, max])
      end
      |> Enum.map(fn pid -> {pid, ""} end)

    {:noreply,
     assign(socket,
       responses: responses,
       form_count: count,
       form_tmin: min,
       form_tmax: max
     )}
  end

  def do_work(from, min, max) do
    case Myapp.Meshx.Worker.do_work(min, max) do
      {:ok, id} -> send(from, {:rpc_ok, id, self()})
      {:error_rpc, err} -> send(from, {:rpc_error, to_string(err), self()})
      _ -> send(from, {:rpc_error, "error", self()})
    end
  end
end
