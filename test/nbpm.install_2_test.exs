defmodule Mix.Tasks.Nbpm.Install2Test do
  use ExUnit.Case

  import ExUnit.CaptureIO
  import NbpmTest.Support

  alias Mix.Tasks.Nbpm.Install

  test "install to projects without './rel' dir with manual confirmation, say \"y\"" do
    dbg("b1")
    {:ok, _} = delete_rel_dir()
    dbg("b2")
    assert capture_io("y\n", fn -> Install.run([]) end) =~ "creating \e[0mrel/env.sh.eex"
    dbg("b3")
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
