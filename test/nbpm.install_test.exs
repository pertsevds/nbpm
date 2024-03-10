defmodule Mix.Tasks.Nbpm.InstallTest do
  use ExUnit.Case, async: true

  # import ExUnit.CaptureIO

  alias Mix.Tasks.Nbpm.Install

  # def assert_node_to_listen_port({input, expected}) do
  #   assert "#{expected}\n" == capture_io(fn -> GetPortNumber.run([input]) end)
  # end

  def delete_rel_dir do
    File.rm_rf("./rel")
  end

  describe "test installation to project" do
    test "install to projects without './rel' dir" do
      {:ok, _} = delete_rel_dir()
      Install.run([])
    end

    # test "get listen port by project app" do
    #   assert "2937\n" == capture_io(fn -> GetPortNumber.run([]) end)
    # end
  end
end
