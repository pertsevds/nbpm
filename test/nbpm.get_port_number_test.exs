defmodule Mix.Tasks.Nbpm.GetPortNumberTest do
  use ExUnit.Case

  import ExUnit.CaptureIO
  import NbpmTest.Support

  alias Mix.Tasks.Nbpm.GetPortNumber

  def assert_node_to_listen_port({input, expected}) do
    assert "#{expected}\n" == capture_io(fn -> GetPortNumber.run([input]) end)
  end

  describe "test get port number" do
    test "get listen port by arg" do
      Enum.each(nodes_ports(), &assert_node_to_listen_port/1)
    end

    test "get listen port by project app" do
      assert "2937\n" == capture_io(fn -> GetPortNumber.run([]) end)
    end
  end
end