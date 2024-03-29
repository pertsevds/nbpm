defmodule Mix.Tasks.Nbpm.Install do
  @shortdoc "Installs `Nbpm` into `Mix.Release` scripts."

  @moduledoc "Installs `Nbpm` into `Mix.Release` scripts."
  use Mix.Task

  defp init_script(script, false) do
    IO.puts("#{script} was not found.")
    run_init = IO.gets("Run `mix release.init`? [Y/n]")

    if run_init in ["Y\n", "y\n"] do
      Mix.Task.rerun("release.init")
    else
      {:stop,
       """
       Script was not found and you don't want to create it.
       Exiting.\
       """}
    end
  end

  defp init_script(_script, _confirm) do
    Mix.Task.rerun("release.init")
  end

  defp modify_script(script, contents, string, pattern) do
    exist = String.contains?(contents, string)

    if exist do
      :ok
    else
      new_contents = Regex.replace(pattern, contents, "\\1\n" <> string, global: false)
      File.write(script, new_contents)
    end
  end

  defp modify_os_script(confirm, filename, string, pattern) do
    case File.read(filename) do
      {:ok, contents} ->
        modify_script(filename, contents, string, pattern)

      {:error, :enoent} ->
        with :ok <- init_script(filename, confirm) do
          modify_os_script(confirm, filename, string, pattern)
        end
    end
  end

  defp modify_without_confirmation(confirm) do
    with :ok <-
           modify_os_script(
             confirm,
             "rel/env.sh.eex",
             "export ELIXIR_ERL_OPTIONS=\"-start_epmd false -epmd_module Elixir.Nbpm $ELIXIR_ERL_OPTIONS\"\n",
             ~r/(#!\/bin\/sh\n)/
           ),
         :ok <-
           modify_os_script(
             confirm,
             "rel/env.bat.eex",
             "set ELIXIR_ERL_OPTIONS=-start_epmd false -epmd_module Elixir.Nbpm %ELIXIR_ERL_OPTIONS%\n\n",
             ~r/(@echo off\n)/
           ) do
      :ok
    else
      {:stop, str} ->
        IO.puts(str)
        :ok

      _ ->
        IO.puts(:stderr, "Error when script modified")
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
