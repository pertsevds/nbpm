defmodule NbpmTest do
  use ExUnit.Case, async: true

  import NbpmTest.Support

  doctest Nbpm

  def assert_name_to_port({input, expected}) do
    assert {:ok, ^expected} = Nbpm.name_to_port(input)
  end

  def assert_node_to_port({input, expected}) do
    assert {:port, ^expected, 5} = Nbpm.port_please(input, ~c"127.0.0.1", 5_000)
  end

  def assert_node_to_listen_port({input, expected}) do
    assert {:ok, ^expected} = Nbpm.listen_port_please(input, ~c"127.0.0.1")
  end

  describe "name_to_port/1" do
    test "converts valid node names to ports" do
      Enum.each(nodes_ports(), &assert_name_to_port/1)

      nodes_ports()
      |> Enum.map(fn {string, port} -> {to_charlist(string), port} end)
      |> Enum.each(&assert_name_to_port/1)

      nodes_ports()
      |> Enum.map(fn {string, port} -> {String.to_atom(string), port} end)
      |> Enum.each(&assert_name_to_port/1)
    end
  end

  describe "start_link/0" do
    test "start ignored" do
      assert :ignore = Nbpm.start_link()
    end
  end

  describe "names/0" do
    test "don't know any names" do
      assert {:error, "I don't know what other nodes there are."} = Nbpm.names(~c"127.0.0.1")
    end
  end

  describe "register_node/3" do
    test "registers a node with a random creation" do
      {:ok, creation} = Nbpm.register_node(~c"my-random-name-12345", 12_345, :inet)
      assert is_integer(creation)
    end
  end

  describe "port_please/3" do
    test "returns the port for a valid node name" do
      Enum.each(nodes_ports(), &assert_node_to_port/1)
    end
  end

  describe "address_please/3" do
    test "returns the address for a given host and address family" do
      assert {:ok, {127, 0, 0, 1}} = Nbpm.address_please(~c"my-random-name", ~c"localhost", :inet)
    end
  end

  describe "listen_port_please/2" do
    test "returns the port for a valid node name" do
      Enum.each(nodes_ports(), &assert_node_to_listen_port/1)
    end
  end
end
