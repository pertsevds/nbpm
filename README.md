# Name-Based Port Mapper (Nbpm)

Nbpm is a lightweight Elixir module that provides a simplified implementation of the Erlang Port Mapper Daemon (EPMD) protocol. It enables basic functionality for mapping Erlang node names to network ports and handles the registration of nodes. This module is designed as a convenient alternative to a full EPMD implementation, making it easier to facilitate communication between Erlang nodes.

## Compatibility
Nbpm is compatible with Mix releases. When you execute `"_build/prod/rel/your_app/bin/your_app remote"`, it automatically generates node names in the format "rem-$(rand)-name" or "rem-$(rand)-sname". Similarly, when you use `"_build/prod/rel/your_app/bin/your_app rpc"`, it generates "rpc-$(rand)-name" or "rpc-$(rand)-sname". Nbpm responds to these names by offering port number 0, indicating that the OS should assign a random port.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `nbpm` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nbpm, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/nbpm>.

