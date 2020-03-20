import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

es_database_url =
  System.get_env("ES_DATABASE_URL") ||
    raise """
    environment variable ES_DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

static_url =
  case System.get_env("BONFIRE_CDN", "false") do
    "false" ->
      nil

    url ->
      url
      |> URI.parse()
      |> Map.take([:scheme, :port, :host, :path])
      |> Map.to_list()
  end

config :bonfire, BonfireWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  static_url: static_url,
  secret_key_base: secret_key_base

config :bonfire, Bonfire.Repo,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :bonfire, Bonfire.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  url: es_database_url,
  pool_size: String.to_integer(System.get_env("ES_REPO_POOL_SIZE") || "10")
