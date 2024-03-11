defmodule Mix.Tasks.Nbpm.InstallTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Mix.Tasks.Nbpm.Install

  defp delete_rel_dir do
    File.rm_rf("./rel")
  end

  defp file_contains?(file, string) do
    with {:ok, contents} <- File.read(file),
         true <- String.contains?(contents, string) do
      true
    else
      _ -> false
    end
  end

  defp unix_string do
    "export ELIXIR_ERL_OPTIONS=\"-start_epmd false -epmd_module Elixir.Nbpm $ELIXIR_ERL_OPTIONS\""
  end

  defp unix_path do
    "rel/env.sh.eex"
  end

  defp win32_string do
    "set ELIXIR_ERL_OPTIONS=-start_epmd false -epmd_module Elixir.Nbpm %ELIXIR_ERL_OPTIONS%"
  end

  defp win32_path do
    "rel/env.bat.eex"
  end

  defp scripts_changed do
    with true <- file_contains?(unix_path(), unix_string()),
         true <- file_contains?(win32_path(), win32_string()) do
      true
    else
      _ -> false
    end
  end

  describe "test installation to project" do
    test "install to projects without './rel' dir without manual confirmation" do
      {:ok, _} = delete_rel_dir()
      assert capture_io("y\n", fn -> Install.run(["-y"]) end) =~ "rel/env.sh.eex"
      assert scripts_changed() == true
    end

    test "install to projects without './rel' dir with manual confirmation, say \"y\"" do
      {:ok, _} = delete_rel_dir()

      assert capture_io("y\n", fn -> Install.run([]) end) =~ "rel/env.sh.eex"
      assert scripts_changed() == true
    end

    # test "install to projects without './rel' dir with manual confirmation, but say \"n\"" do
    #   {:ok, _} = delete_rel_dir()
    #   assert capture_io("n\n", fn -> Install.run([]) end) == "rel/env.sh.eex was not found.\nRun `mix release.init`? [Y/n]"
    #   # assert scripts_changed() == false
    # end

    # test "install to projects with existing './rel' dir without manual confirmation" do
    #   {:ok, _} = delete_rel_dir()
    #   Mix.Task.run("release.init")
    #   Install.run(["-y"])
    # end

    # test "install to projects with existing './rel' dir without manual confirmation, but make it 2 times" do
    #   {:ok, _} = delete_rel_dir()
    #   Mix.Task.run("release.init")
    #   Install.run(["-y"])
    #   Install.run(["-y"])
    # end
  end
end
