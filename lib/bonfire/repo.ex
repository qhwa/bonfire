defmodule Bonfire.Repo do
  use Ecto.Repo,
    otp_app: :bonfire,
    adapter: Ecto.Adapters.Postgres
end
