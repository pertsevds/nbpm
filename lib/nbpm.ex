defmodule Nbpm do
  @moduledoc """
  # Name-Based Port Mapper (Nbpm)

  Nbpm is a lightweight Elixir module that provides a simplified implementation of the Erlang Port Mapper Daemon (EPMD) protocol. It enables basic functionality for mapping Erlang node names to network ports and handles the registration of nodes. This module is designed as a convenient alternative to a full EPMD implementation, making it easier to facilitate communication between Erlang nodes.

  ## Compatibility
  Nbpm is compatible with Mix releases. When you execute `"_build/prod/rel/your_app/bin/your_app remote"`, it automatically generates node names in the format "rem-$(rand)-name" or "rem-$(rand)-sname". Similarly, when you use `"_build/prod/rel/your_app/bin/your_app rpc"`, it generates "rpc-$(rand)-name" or "rpc-$(rand)-sname". Nbpm responds to these names by offering port number 0, indicating that the OS should assign a random port.
  """

  # The distribution protocol version number has been 5 ever since Erlang/OTP R6.
  @version 5

  def name_to_port(name) when is_atom(name) do
    name_to_port(Atom.to_string(name))
  end

  def name_to_port(name) when is_list(name) do
    name_to_port(List.to_string(name))
  end

  def name_to_port(name) when is_binary(name) do
    port_regex = ~r/^(?<rpc>rpc-)|(?<rem>rem-)|.*-(?<port>(?!0)\d{1,5})$/
    matches = Regex.named_captures(port_regex, name)

    case matches do
      %{"rpc" => "rpc-"} ->
        {:ok, 0}

      %{"rem" => "rem-"} ->
        {:ok, 0}

      %{"port" => port} ->
        {:ok, String.to_integer(port)}

      _ ->
        {:error, "Invalid node name format: #{name}. It must be `name-port`, `rem-anything`, or `rpc-anything`."}
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
    port = name_to_port(name)

    case port do
      {:ok, port} -> {:port, port, @version}
      {:error, error} -> {:error, error}
    end
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
