defmodule Bonfire.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Application.put_env(:bonfire, :pow_assent, pow_assent_config())

    :telemetry.attach(
      "appsignal-ecto",
      [:bonfire, :repo, :query],
      &Appsignal.Ecto.handle_event/4,
      nil
    )

    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Bonfire.Repo,
      # Start the endpoint when the application starts
      BonfireWeb.Endpoint,
      # Starts a worker by calling: Bonfire.Worker.start_link(arg)
      # {Bonfire.Worker, arg},
      Bonfire.EventApp,
      Bonfire.Tracks.Supervisor,
      Bonfire.Sharing.Supervisor,
      Bonfire.Games.Supervisor,
      Bonfire.Pushes.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bonfire.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp pow_assent_config do
    Application.get_env(:bonfire, :pow_assent, [])
    |> Keyword.put(:providers, pow_assent_providers())
  end

  defp pow_assent_providers do
    [github: true, google: false]
    |> Enum.reduce([], fn {name, default_on}, providers ->
      uname = name |> to_string() |> String.upcase()

      case System.get_env("BONFIRE_AUTH_WITH_#{uname}", to_string(default_on)) do
        "false" ->
          providers

        _ ->
          [{name, pow_assent_provider_config(uname)} | providers]
      end
    end)
  end

  defp pow_assent_provider_config(name) do
    [
      client_id: System.fetch_env!("BONFIRE_#{name}_CLIENT_ID"),
      client_secret: System.fetch_env!("BONFIRE_#{name}_CLIENT_SECRET"),
      strategy: Module.concat([Assent.Strategy, String.capitalize(name)])
    ]
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BonfireWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
