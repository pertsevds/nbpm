defmodule Mix.Tasks.Nbpm.Install do
  @shortdoc "Insatlls `Nbpm` into `Mix.Release` scripts"

  @moduledoc "Insatlls `Nbpm` into `Mix.Release` scripts."

  use Mix.Task

  defp init_script(script) do
    IO.puts("#{script} was not found.")
    run_init = IO.gets("Run `mix release.init`? [Y/n]")

    if run_init not in ["Y\n", "y\n"] do
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

    if not exist do
      new_contents = Regex.replace(pattern, contents, "\\1\n" <> string <> "\n\n", global: false)
      :ok = File.write(script, new_contents)
    end

    :ok
  end

  defp modify_linux_script do
    script = "rel/env.sh.eex"

    string =
      "export ELIXIR_ERL_OPTIONS=\"-start_epmd false -epmd_module Elixir.Nbpm $ELIXIR_ERL_OPTIONS\""

    pattern = ~r/(#!\/bin\/sh\n\n)/

    case File.read(script) do
      {:ok, contents} ->
        modify_script(script, contents, string, pattern)

      {:error, :enoent} ->
        :ok = init_script(script)
        {:ok, contents} = File.read(script)
        modify_script(script, contents, string, pattern)
    end
  end

  defp modify_windows_script do
    script = "rel/env.bat.eex"

    string =
      "set ELIXIR_ERL_OPTIONS=-start_epmd false -epmd_module Elixir.Nbpm %ELIXIR_ERL_OPTIONS%"

    pattern = ~r/(@echo off\n)/

    case File.read(script) do
      {:ok, contents} ->
        modify_script(script, contents, string, pattern)

      {:error, :enoent} ->
        :ok = init_script(script)
        {:ok, contents} = File.read(script)
        modify_script(script, contents, string, pattern)
    end
  end

  @doc false
  def run(_) do
    :ok = modify_linux_script()
    :ok = modify_windows_script()
  end
end
