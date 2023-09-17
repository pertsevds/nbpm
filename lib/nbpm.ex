defmodule Nbpm do
  @moduledoc """
  Main module for Name-Based Port Mapper (Nbpm).

  This module provides the core functionality for mapping node names to port
  numbers in the context of Erlang distribution. It is designed to be used as
  a custom EPMD (Erlang Port Mapper Daemon) module, which you can specify
  with the `-epmd_module` option.

  ## Node name to port number mapping variants

  - **Last up to 5 digits:** If the node name ends with digits, the last up to
  5 digits from the node name are considered as the port number. For example,
  for a node name "my_node12345" the port number would be 12345.

  - **Special Prefixes:** If a node name starts with "rem-" or "rpc-," it
  indicates that the OS should assign a random port. This is for
  compatibility with `Mix.Release`.

  - **Hash-Based Port:** If none of the previous options match, the node name
  is hashed using the `:erlang.phash2` function, and the resulting hash is
  used as the port number. The port range is from 1024 to 65535.
  `:erlang.phash2` is a portable hash function that gives the same hash for
  the same Erlang term regardless of machine architecture and ERTS version,
  thia ensures consistent name-to-port mappings across different machine
  architectures and ERTS versions.

  To determine to which port your node name translates, you can use the
  `name_to_port/1` function provided by this module.

  ## Compatibility

  Nbpm is compatible with Mix releases. When you execute
  `"_build/prod/rel/your_app/bin/your_app remote"`, it automatically
  generates node names in the format "rem-$(rand)-name" or
  "rem-$(rand)-sname". Similarly, when you execute
  `"_build/prod/rel/your_app/bin/your_app rpc"`, it generates
  "rpc-$(rand)-name" or "rpc-$(rand)-sname".
  Nbpm responds to these names by offering port number 0, indicating that the
  OS should assign a random port.

  ## References

  * [How to Implement an Alternative Node Discovery for Erlang Distribution](https://www.erlang.org/doc/apps/erts/alt_disco)
  * `Mix.Release`
  """

  # The distribution protocol version number has been 5 ever since Erlang/OTP R6.
  @version 5

  @minimum_port 1_024
  @maximum_port 65_535

  def available_ports_count do
    @maximum_port - @minimum_port + 1
  end

  defp get_port_by_name(str) do
    :erlang.phash2(str, available_ports_count()) + 1_024
  end

  def name_to_port(name) when is_atom(name) do
    name_to_port(Atom.to_string(name))
  end

  def name_to_port(name) when is_list(name) do
    name_to_port(List.to_string(name))
  end

  @doc """
  Translates node name to port number.
  """
  def name_to_port(name) when is_binary(name) do
    port_regex = ~r/^(?<rpc>rpc-)|(?<rem>rem-)|(?<port>(?!0)\d{1,5})$/
    matches = Regex.named_captures(port_regex, name)

    case matches do
      %{"rpc" => "rpc-"} ->
        {:ok, 0}

      %{"rem" => "rem-"} ->
        {:ok, 0}

      %{"port" => port} ->
        {:ok, String.to_integer(port)}

      _ ->
        {:ok, get_port_by_name(name)}
    end
  end

  def start_link do
    :ignore
  end

  def register_node(name, port, _driver) do
    register_node(name, port)
  end

  def register_node(_name, _port) do
    creation = :rand.uniform(3)
    {:ok, creation}
  end

  def port_please(name, ip, _timeout) do
    port_please(name, ip)
  end

  def port_please(name, _ip) do
    {:ok, port} = name_to_port(name)
    {:port, port, @version}
  end

  def names(_hostname) do
    {:error, "I don't know what other nodes there are."}
  end

  def address_please(_name, host, address_family) do
    :inet.getaddr(host, address_family)
  end

  def listen_port_please(name, _host) do
    name_to_port(name)
  end
end
