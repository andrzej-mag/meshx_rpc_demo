defmodule Service.Meshx.Worker do
  use MeshxRpc.Server,
    telemetry_prefix: [:service, __MODULE__]

  def do_work([t1, t2]) when is_integer(t1) and is_integer(t2) do
    random_time(t1, t2) |> Process.sleep()
    {:ok, :persistent_term.get({:service, :id})}
  end

  defp random_time(t1, t2) do
    {min, max} =
      cond do
        t1 < t2 -> {t1, t2}
        t1 > t2 -> {t2, t1}
        true -> {0, t1}
      end

    :rand.uniform(max - min) + min
  end
end
