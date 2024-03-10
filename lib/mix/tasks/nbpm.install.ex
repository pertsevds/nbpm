defmodule Mix.Tasks.Nbpm.Install do
  @shortdoc "Installs `Nbpm` into `Mix.Release` scripts."

  @moduledoc "Installs `Nbpm` into `Mix.Release` scripts."
  use Mix.Task

  defp init_script(script) do
    IO.puts("#{script} was not found.")
    run_init = IO.gets("Run `mix release.init`? [Y/n]")

    unless run_init in ["Y\n", "y\n"] do
      IO.puts("""
      Script was not found and you don't want to create it.
      Exiting.
      """)

      System.halt(0)
    end

    Mix.Task.run("release.init")
  end

  defp modify_script(script, contents, string, pattern) do
    exist = String.contains?(contents, string)

    unless exist do
      new_contents = Regex.replace(pattern, contents, "\\1\n" <> string <> "\n\n", global: false)
      :ok = File.write(script, new_contents)
    end

    :ok
  end

  defp modify_unix_script do
    script = "rel/env.sh.eex"

    string =
      "export ELIXIR_ERL_OPTIONS=\"-start_epmd false -epmd_module Elixir.Nbpm $ELIXIR_ERL_OPTIONS\""

    pattern = ~r/(#!\/bin\/sh\n\n)/

    case File.read(script) do
      {:ok, contents} ->
        modify_script(script, contents, string, pattern)

      {:error, :enoent} ->
        :ok = init_script(script)
        modify_unix_script()
    end
  end

  defp modify_win32_script do
    script = "rel/env.bat.eex"

    string =
      "set ELIXIR_ERL_OPTIONS=-start_epmd false -epmd_module Elixir.Nbpm %ELIXIR_ERL_OPTIONS%"

    pattern = ~r/(@echo off\n)/

    case File.read(script) do
      {:ok, contents} ->
        modify_script(script, contents, string, pattern)

      {:error, :enoent} ->
        :ok = init_script(script)
        modify_win32_script()
    end
  end

  @impl Mix.Task
  def run(_) do
    :ok = modify_unix_script()
    :ok = modify_win32_script()
  end
end
