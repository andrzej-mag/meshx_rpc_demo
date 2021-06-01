# MeshxRpc Demo - Service Provider

## Installation
After cloning repository, configure and start application:
```shell
cd service
mix deps.get && mix compile
# edit config/[dev, test].exs with your Consul agent settings
iex --erl "-start_epmd false" -S mix
```

## Code
Application using dynamic supervisor defined in `Service.Meshx.Supervisor` module starts mesh service provider defined in `Service.Meshx.Worker`. Details of mesh service providers and upstream clients are described in `MeshxRpc` package [documentation](https://hexdocs.pm/meshx_rpc).

`Service.Meshx.Worker` exposes to remote RPC clients one function: `do_work([tmin, tmax])`. Function sleeps for a random amount of time in `tmin..tmax` range simulating some work (e.g. jpg image processing/classification task) and returns `{:ok, service_id}`.
