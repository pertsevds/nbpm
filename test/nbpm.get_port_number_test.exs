defmodule Mix.Tasks.Nbpm.GetPortNumberTest do
  use ExUnit.Case
  use Patch

  import ExUnit.CaptureIO
  import NbpmTest.Support

  defp assert_cmd_arg_to_listen_port({input, expected}) do
    assert "#{expected}\n" ==
             capture_io(fn -> Mix.Task.rerun("nbpm.get_port_number", [input]) end)
  end

  defp assert_app_name_to_listen_port({input, expected}) do
    patch_app_in_mix_project(input)
    assert "#{expected}\n" == capture_io(fn -> Mix.Task.rerun("nbpm.get_port_number", []) end)
    restore_app_in_mix_project()
  end

  defp patch_app_in_mix_project(app_name) do
    cfg = Mix.Project.config()
    cfg = Keyword.put(cfg, :app, :"#{app_name}")
    patch(Mix.Project, :config, cfg)
  end

  defp restore_app_in_mix_project do
    restore(Mix.Project)
  end

  describe "test get port number" do
    test "get listen port by command line argument" do
      Enum.each(names_to_ports(), &assert_cmd_arg_to_listen_port/1)
    end

    test "get listen port by project app name" do
      Enum.each(names_to_ports(), &assert_app_name_to_listen_port/1)
    end
  end
end
