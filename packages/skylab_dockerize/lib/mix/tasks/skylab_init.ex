defmodule Mix.Tasks.Skylab.Init do
  alias IO.ANSI
  require Logger

  @moduledoc """
  Initialize Skylab configurations

  Usage: `mix skylab.init --app my_app`

  Supported arguments:

  * `--app`
  * `--overwrite`
  """

  def run(opts) do
    parse_args(opts) |> Skylab.Generate.gen()
  end

  defp parse_args(args) do
    OptionParser.parse(args,
      strict: [
        app: :string,
        overwrite: :boolean,
        elixir_version: :string
      ]
    )
    |> case do
      {options, [], []} ->
        options

      {_, args, []} ->
        IO.puts(["Unrecognized arguments: ", ANSI.red(), Enum.join(args, " "), ANSI.reset(), "\n"])
        print_usage()
        System.halt(1)

      {_, _, invalid} ->
        IO.puts(["Unrecognized options: ", ANSI.red(), inspect(invalid), ANSI.reset(), "\n"])
        print_usage()
        System.halt(1)
    end
  end

  defp print_usage, do: Mix.Tasks.Help.run(["skylab.init"]) 
end
