defmodule NbpmTest do
  use ExUnit.Case

  describe "name_to_port/1" do
    test "converts valid node names to ports" do
      assert {:ok, 12_345} = Nbpm.name_to_port(~c"my-node-12345")
      assert {:ok, 0} = Nbpm.name_to_port(~c"rpc-random-name")
      assert {:ok, 0} = Nbpm.name_to_port(~c"rem-random-sname")
      assert {:ok, 12_345} = Nbpm.name_to_port(:"my-node-12345")
      assert {:ok, 0} = Nbpm.name_to_port(:"rpc-random-name")
      assert {:ok, 0} = Nbpm.name_to_port(:"rem-random-sname")
    end

    test "handles invalid node names" do
      assert {:error,
              "Invalid node name format: invalid-node-name. It must be `name-port`, `rem-anything`, or `rpc-anything`."} =
               Nbpm.name_to_port(~c"invalid-node-name")

      assert {:error, "Invalid node name format: random-name. It must be `name-port`, `rem-anything`, or `rpc-anything`."} =
               Nbpm.name_to_port(~c"random-name")
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
      {:ok, creation} = Nbpm.register_node(~c"my-node", 12_345, :inet)
      assert is_integer(creation)
    end
  end

  describe "port_please/3" do
    test "returns the port for a valid node name" do
      assert {:port, 12_345, 5} = Nbpm.port_please(~c"my-node-12345", ~c"127.0.0.1", 5_000)
      assert {:port, 0, 5} = Nbpm.port_please(~c"rpc-random-name", ~c"127.0.0.1", 5_000)
      assert {:port, 0, 5} = Nbpm.port_please(~c"rem-random-sname", ~c"127.0.0.1", 5_000)
    end

    test "handles invalid node names" do
      assert {:error,
              "Invalid node name format: invalid-node-name. It must be `name-port`, `rem-anything`, or `rpc-anything`."} =
               Nbpm.port_please(~c"invalid-node-name", ~c"127.0.0.1", 5_000)

      assert {:error, "Invalid node name format: random-name. It must be `name-port`, `rem-anything`, or `rpc-anything`."} =
               Nbpm.port_please(~c"random-name", ~c"127.0.0.1", 5_000)
    end
  end

  describe "address_please/3" do
    test "returns the address for a given host and address family" do
      assert {:ok, {127, 0, 0, 1}} = Nbpm.address_please("my-node-12345", ~c"localhost", :inet)
    end
  end

  describe "listen_port_please/2" do
    test "returns the port for a valid node name" do
      assert {:ok, 12_345} = Nbpm.listen_port_please(~c"my-node-12345", ~c"127.0.0.1")
      assert {:ok, 0} = Nbpm.listen_port_please(~c"rpc-random-name", ~c"127.0.0.1")
      assert {:ok, 0} = Nbpm.listen_port_please(~c"rem-random-sname", ~c"127.0.0.1")
    end

    test "handles invalid node names" do
      assert {:error,
              "Invalid node name format: invalid-node-name. It must be `name-port`, `rem-anything`, or `rpc-anything`."} =
               Nbpm.listen_port_please(~c"invalid-node-name", ~c"127.0.0.1")

      assert {:error, "Invalid node name format: random-name. It must be `name-port`, `rem-anything`, or `rpc-anything`."} =
               Nbpm.listen_port_please(~c"random-name", ~c"127.0.0.1")
    end
  end
end
