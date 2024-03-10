defmodule Mix.Tasks.Nbpm.Install do
  @shortdoc "Installs `Nbpm` into `Mix.Release` scripts."

  @moduledoc "Installs `Nbpm` into `Mix.Release` scripts."
  use Mix.Task

  defp init_script(script, false) do
    IO.puts("#{script} was not found.")
    run_init = IO.gets("Run `mix release.init`? [Y/n]")

    if run_init in ["Y\n", "y\n"] do
      Mix.Task.run("release.init")
    else
      {:error,
       """
       Script was not found and you don't want to create it.
       Exiting.\
       """}
    end
  end

  defp init_script(_script, _confirm) do
    Mix.Task.run("release.init")
  end

  defp modify_script(script, contents, string, pattern) do
    exist = String.contains?(contents, string)

    if exist do
      :ok
    else
      new_contents = Regex.replace(pattern, contents, "\\1\n" <> string <> "\n\n", global: false)
      File.write(script, new_contents)
    end
  end

  defp modify_unix_script(confirm) do
    script = "rel/env.sh.eex"

    string =
      "export ELIXIR_ERL_OPTIONS=\"-start_epmd false -epmd_module Elixir.Nbpm $ELIXIR_ERL_OPTIONS\""

    pattern = ~r/(#!\/bin\/sh\n\n)/

    case File.read(script) do
      {:ok, contents} ->
        modify_script(script, contents, string, pattern)

      {:error, :enoent} ->
        with :ok <- init_script(script, confirm) do
          modify_unix_script(confirm)
        end
    end
  end

  defp modify_win32_script(confirm) do
    script = "rel/env.bat.eex"

    string =
      "set ELIXIR_ERL_OPTIONS=-start_epmd false -epmd_module Elixir.Nbpm %ELIXIR_ERL_OPTIONS%"

    pattern = ~r/(@echo off\n)/

    case File.read(script) do
      {:ok, contents} ->
        modify_script(script, contents, string, pattern)

      {:error, :enoent} ->
        with :ok <- init_script(script, confirm) do
          modify_win32_script(confirm)
        end
    end
  end

  defp modify_without_confirmation(confirm) do
    with :ok <- modify_unix_script(confirm),
         :ok <- modify_win32_script(confirm) do
      :ok
    else
      {:error, error} ->
        IO.puts(:stderr, error)
        :error
    end
  end

  @impl Mix.Task
  def run(["-y"]) do
    modify_without_confirmation(true)
  end

  @impl Mix.Task
  def run(_) do
    modify_without_confirmation(false)
  end
end
