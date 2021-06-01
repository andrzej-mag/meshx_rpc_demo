defmodule Service.MixProject do
  use Mix.Project

  def project do
    [
      app: :service,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Service.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:meshx_consul, "~> 0.1.0"},
      {:meshx_rpc, "~> 0.1.1"},
      {:ranch, "~> 1.8.0"}
    ]
  end
end
