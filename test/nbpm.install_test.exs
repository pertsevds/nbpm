defmodule Mix.Tasks.Nbpm.Install1Test do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Mix.Tasks.Nbpm.Install

  def delete_rel_dir do
    File.rm_rf("./rel")
  end

  def file_contains?(file, string) do
    with {:ok, contents} <- File.read(file),
         true <- String.contains?(contents, string) do
      true
    else
      _ -> false
    end
  end

  def unix_string do
    "export ELIXIR_ERL_OPTIONS=\"-start_epmd false -epmd_module Elixir.Nbpm $ELIXIR_ERL_OPTIONS\""
  end

  def unix_path do
    "rel/env.sh.eex"
  end

  def win32_string do
    "set ELIXIR_ERL_OPTIONS=-start_epmd false -epmd_module Elixir.Nbpm %ELIXIR_ERL_OPTIONS%"
  end

  def win32_path do
    "rel/env.bat.eex"
  end

  def scripts_changed do
    with true <- file_contains?(unix_path(), unix_string()),
         true <- file_contains?(win32_path(), win32_string()) do
      true
    else
      _ -> false
    end
  end

  test "install to projects without './rel' dir without manual confirmation" do
    {:ok, _} = delete_rel_dir()
    assert capture_io(fn -> Install.run(["-y"]) end) =~ "creating"
    assert scripts_changed() == true
  end

  test "install to projects without './rel' dir with manual confirmation, say \"y\"" do
    {:ok, _} = delete_rel_dir()
    assert capture_io("y\n", fn -> Install.run([]) end) =~ "creating"
    assert scripts_changed() == true
  end

  test "install to projects without './rel' dir with manual confirmation, but say \"n\"" do
    {:ok, _} = delete_rel_dir()
    assert capture_io("n\n", fn -> Install.run([]) end) =~ "rel/env.sh.eex was not found."
    assert scripts_changed() == false
  end

  test "install to projects with existing './rel' dir without manual confirmation, but make it 2 times" do
    {:ok, _} = delete_rel_dir()
    assert capture_io(fn -> Install.run(["-y"]) end) =~ "creating"
    assert capture_io(fn -> Install.run(["-y"]) end) == ""
  end
end
