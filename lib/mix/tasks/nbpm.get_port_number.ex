defmodule Mix.Tasks.Nbpm.GetPortNumber do
  @shortdoc "Get port number"

  @moduledoc """
  Get port number.

  Without arguments
  `mix nbpm.get_port_number`
  prints current project application port.

  With one argument
  `mix nbpm.get_port_number my_app`
  prints port number for that argument.

  """
  use Mix.Task

  @impl Mix.Task
  def run([]) do
    app = Application.get_application(__MODULE__)
    {:ok, port_number} = Nbpm.name_to_port("#{app}")
    IO.puts(port_number)
  end

  @impl Mix.Task
  def run(args) when is_list(args) do
    {:ok, port_number} = Nbpm.name_to_port(hd(args))
    IO.puts(port_number)
  end
end
