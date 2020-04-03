defmodule Bonfire do
  @moduledoc """
  Bonfire keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def migrate_db() do
    Bonfire.Repo.__adapter__().storage_up(Bonfire.Repo.config())
    path = Application.app_dir(:bonfire, "priv/repos/migrations")
    Ecto.Migrator.run(Bonfire.Repo, path, :up, all: true)

    es_config = Bonfire.EventStore.config()
    EventStore.Tasks.Create.exec(es_config, [])
    EventStore.Tasks.Migrate.exec(es_config, [])
  end
end
