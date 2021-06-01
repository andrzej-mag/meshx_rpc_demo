use Mix.Config

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
