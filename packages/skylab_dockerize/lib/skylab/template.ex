defmodule Skylab.Template do
  @moduledoc """
  模板相关 helper 方法
  """

  @doc """
  获取模板文件对应的实际路径。有两种策略:
  1. 在 skylab 项目开发时，使用 "./template"
  2. 在作为 hex 依赖时，使用 "./deps/skylab/template"

  ## Example

  iex> Skylab.Template.input_path("a", base: "")
  "priv/template/a.eex"

  iex> Skylab.Template.input_path("x/y.html", base: "")
  "priv/template/x/y.html.eex"

  iex> Skylab.Template.input_path("foo", base: "bar")
  "bar/priv/template/foo.eex"
  """
  def input_path(file, opts \\ []) do
    Path.join([base_path(opts), "template", file <> ".eex"])
  end

  @doc """
  获取模板文件对应输出路径

  ## Example

  iex> Skylab.Template.output_path("a", base: "")
  "a"

  iex> Skylab.Template.output_path("x/y.html", base: "")
  "x/y.html"

  iex> Skylab.Template.output_path("foo", base: "bar")
  "foo"

  iex> Skylab.Template.output_path("foo", base: "bar", output: "baz")
  "baz/foo"
  """
  def output_path(file, opts \\ []) do
    Path.join([
      Keyword.get(opts, :output, ""),
      file
    ])
  end

  defp base_path(opts) do
    opts
    |> Keyword.get(:base, Application.app_dir(:skylab_dockerize))
    |> Path.join("priv")
  end

  def generate_from_templates(templates, opts) do
    for t <- templates, do: generate_from_template(t, opts)
  end

  def generate_from_template(template, opts) do
    input = input_path(template, opts)
    output = output_path(template, opts)

    prepair_dir(output)

    if !File.exists?(output) || confirm(output, opts) do
      IO.puts(["generating ", output])
      File.write!(output, EEx.eval_file(input, opts))
    end
  end

  defp prepair_dir(file) do
    file
    |> Path.dirname()
    |> File.mkdir_p()
  end

  defp confirm(output, opts) do
    Keyword.get(opts, :overwrite) || yes?("Overwrite #{output}?")
  end

  defp yes?(question) do
    IO.gets([question, " (Y/n)"])
    |> String.trim()
    |> String.downcase()
    |> case do
      "" ->
        true

      "y" ->
        true

      _ ->
        false
    end
  end
end
