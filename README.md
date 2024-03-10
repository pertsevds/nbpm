# Nbpm

> Name-Based Port Mapper

[![CI](https://github.com/pertsevds/nbpm/actions/workflows/ci.yml/badge.svg)](https://github.com/pertsevds/nbpm/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/pertsevds/nbpm/badge.svg?branch=2-usage-docs)](https://coveralls.io/github/pertsevds/nbpm?branch=2-usage-docs)
[![License](https://img.shields.io/hexpm/l/nbpm.svg)](https://hex.pm/packages/nbpm)
[![Hex pm](https://img.shields.io/hexpm/v/nbpm.svg?style=flat)](https://hex.pm/packages/nbpm)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/nbpm)

With `Nbpm` you don't need EPMD daemon. No additional daemons, no additional configs. Easy and simple distribution without EPMD.

## Features

-   `Mix.Release` compatibility.
-   Ability to specify port number in the node name.
-   Hash-Based Port from node name.

## Installation

To use `Nbpm` in your Elixir project, add it as a dependency in your `mix.exs` file:

```elixir
def deps do
[
    {:nbpm, "~> 0.2.0"}
]
end
```

Run:
```shell
mix nbpm.install
```

This will add `-start_epmd false -epmd_module Elixir.Nbpm` to `ELIXIR_ERL_OPTIONS` in files `rel/env.sh.eex` and `rel/env.bat.eex`.

## TODO

Installation to global: https://github.com/pertsevds/nbpm/issues/4

## Documentation

https://hexdocs.pm/nbpm
