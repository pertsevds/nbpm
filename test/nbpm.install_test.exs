defmodule Mix.Tasks.Nbpm.InstallTest do
  use ExUnit.Case, async: true

  alias Mix.Tasks.Nbpm.Install

  def delete_rel_dir do
    File.rm_rf("./rel")
  end

  describe "test installation to project" do
    test "install to projects without './rel' dir without manual confirmation" do
      {:ok, _} = delete_rel_dir()
      Install.run(["-y"])
    end

    test "install to projects without './rel' dir with manual confirmation, say \"y\"" do
      {:ok, _} = delete_rel_dir()
      Install.run([])
    end

    test "install to projects without './rel' dir with manual confirmation, but say \"n\"" do
      {:ok, _} = delete_rel_dir()
      Install.run([])
    end

    test "install to projects with existing './rel' dir without manual confirmation" do
      {:ok, _} = delete_rel_dir()
      Mix.Task.run("release.init")
      Install.run(["-y"])
    end

    test "install to projects with existing './rel' dir without manual confirmation, but make it 2 times" do
      {:ok, _} = delete_rel_dir()
      Mix.Task.run("release.init")
      Install.run(["-y"])
      Install.run(["-y"])
    end
  end
end
