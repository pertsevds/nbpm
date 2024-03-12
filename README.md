# Nbpm

Name-Based Port Mapper

---

[![CI](https://github.com/pertsevds/nbpm/actions/workflows/ci.yml/badge.svg)](https://github.com/pertsevds/nbpm/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/pertsevds/nbpm/badge.svg?branch=main)](https://coveralls.io/github/pertsevds/nbpm?branch=main)
[![License](https://img.shields.io/hexpm/l/nbpm.svg)](https://hex.pm/packages/nbpm)
[![Hex pm](https://img.shields.io/hexpm/v/nbpm.svg?style=flat)](https://hex.pm/packages/nbpm)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/nbpm)

With Nbpm you don't need EPMD daemon.  
No additional daemons, no additional configs.  
Easy and simple distribution without EPMD.

## Features

- `Mix.Release` compatibility.
- Ability to specify port number in the node name.
- Hash-Based Port from node name.

## Installation

To use `Nbpm` in your Elixir project, add it as a dependency
in your `mix.exs` file:

```elixir
def deps do
[
    {:nbpm, "~> 0.2.0"}
]
end
```

Run

```shell
mix deps.get
```

to download it.

Then run

```shell
mix nbpm.install
```

to install Nbpm into your project.

> `mix nbpm.install` will add `-start_epmd false -epmd_module Elixir.Nbpm` to
> `ELIXIR_ERL_OPTIONS` in files `rel/env.sh.eex` and `rel/env.bat.eex`.
>
> This will disable loading of EPMD daemon
> and will use Nbpm module to map node names to ports.

## Port number task helper

You can determine port number for your current app name
by using `nbpm.get_port_number` task:

```shell
mix nbpm.get_port_number
```

`mix nbpm.get_port_number` will output port number for your current app.

Or you can supply any node name as an argument:

```shell
mix nbpm.get_port_number my_app
```

`mix nbpm.get_port_number my_app` will output port number
for `my_app` node name.

## TODO

Installation to global: <https://github.com/pertsevds/nbpm/issues/4>

## Documentation

<https://hexdocs.pm/nbpm>
