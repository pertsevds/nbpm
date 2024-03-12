defmodule Mix.Tasks.Nbpm.GetPortNumberTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO
  import NbpmTest.Support

  defp assert_node_to_listen_port({input, expected}) do
    assert "#{expected}\n" ==
             capture_io(fn -> Mix.Task.rerun("nbpm.get_port_number", [input]) end)
  end

  describe "test get port number" do
    test "get listen port by arg" do
      Enum.each(nodes_ports(), &assert_node_to_listen_port/1)
    end

    test "get listen port by project app" do
      assert "2937\n" == capture_io(fn -> Mix.Task.rerun("nbpm.get_port_number", []) end)
    end
  end
end
