# MeshxRpc Demo

Basic MeshxRpc capabilities demonstration with Phoenix LiveView.

> Required: HashiCorp [Consul](https://www.consul.io/docs/install) agent with valid [MeshxConsul](https://github.com/andrzej-mag/meshx_consul) configuration.

## Installation
Clone repository:
```shell
git clone https://github.com/andrzej-mag/meshx_rpc_demo
```
Follow installation instructions for:
  * [`myapp`](https://github.com/andrzej-mag/meshx_rpc_demo/tree/master/myapp),
  * [`service`](https://github.com/andrzej-mag/meshx_rpc_demo/tree/master/service).

## Usage
MeshxRpc demo includes two applications:
  * [`myapp`](https://github.com/andrzej-mag/meshx_rpc_demo/tree/master/myapp) Phoenix LiveView application with mesh upstream client consuming mesh service `"myservice"` provided by node(s) running `service` app,
  * [`service`](https://github.com/andrzej-mag/meshx_rpc_demo/tree/master/service) application acting as `"myservice"` mesh service provider.

Start at least one `service` and `myapp` instance. In real world scenario each of `myapp` and `service` instances should run on different hosts/VMs. Usually there should be multiple `service` instances to provide load balancing and high availability for `"myservice"`. For testing purposes both applications can be started on a single machine, including multiple `service` instances.

Visit [`myapp`](https://github.com/andrzej-mag/meshx_rpc_demo/tree/master/myapp) and [`service`](https://github.com/andrzej-mag/meshx_rpc_demo/tree/master/service) folders for further details on installation and usage.
