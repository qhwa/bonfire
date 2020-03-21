use Mix.Config

config :appsignal, :config,
  name: "bonfire",
  push_api_key: System.get_env("BONFIRE_APPSIGNAL_API_KEY"),
  env: Mix.env()
