use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :myapp, MyappWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# MeshxConsul configuration
config :meshx_consul,
  cli_env: [
    {"CONSUL_HTTP_ADDR", "unix:///opt/consul/run/http.sock"},
    {"CONSUL_GRPC_ADDR", "unix:///opt/consul/run/grpc.sock"},
    {"CONSUL_HTTP_TOKEN", ""}
  ],
  httpc_opts: [
    ipfamily: :local,
    unix_socket: '/opt/consul/run/http.sock'
  ],
  httpc_headers: [{'X-Consul-Token', ''}]
