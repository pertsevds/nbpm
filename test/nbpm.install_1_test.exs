defmodule Mix.Tasks.Nbpm.Install1Test do
  use ExUnit.Case

  import ExUnit.CaptureIO
  import NbpmTest.Support

  alias Mix.Tasks.Nbpm.Install

  test "install to projects without './rel' dir without manual confirmation" do
    dbg("a1")
    {:ok, _} = delete_rel_dir()
    dbg("a2")
    assert capture_io(fn -> Install.run(["-y"]) end) =~ "creating \e[0mrel/env.sh.eex"
    dbg("a3")
    assert scripts_changed() == true
  end
end
