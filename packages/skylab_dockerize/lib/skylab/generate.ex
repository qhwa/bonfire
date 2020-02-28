defmodule Skylab.Generate do
  alias Skylab.Template

  @moduledoc """
  Generate Skylab configurations from command line.

  Usage:

  ```sh
  mix skylab.init
  ```
  """

  @default_output ""
  @default_elixir_version "latest"

  @configs ~w[config/releases.exs]
  @dockerfiles ~w[Dockerfile .dockerignore]

  def gen(opts) do
    opts = with_defaults(opts)

    gen_config(opts)
    gen_docker_file(opts)
  end

  defp with_defaults(opts) do
    opts
    |> Keyword.put_new(:app, guess_app_name())
    |> Keyword.put_new(:output, @default_output)
    |> Keyword.put_new(:elixir_version, @default_elixir_version)
  end

  defp guess_app_name do
    Mix.Project.config()
    |> Keyword.get(:app)
    |> to_string()
  end

  defp gen_config(opts),
    do: Template.generate_from_templates(@configs, opts)

  defp gen_docker_file(opts),
    do: Template.generate_from_templates(@dockerfiles, opts)
end
