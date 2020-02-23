defmodule Bonfire.MixProject do
  use Mix.Project

  def project do
    [
      app: :bonfire,
      version: "0.1.0",
      elixir: "~> 1.10-rc",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Bonfire.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.1"},
      {:commanded, "~> 1.0.0"},
      {:commanded_eventstore_adapter, "~> 1.0.0"}
    ]
  end
end
