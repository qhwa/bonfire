defmodule Bonfire.Repo.Migrations.AddFieldsToPushes do
  use Ecto.Migration

  def change do
    alter table(:pushes) do
      add :actions, :binary
      add :allow_dismiss, :boolean
    end
  end
end
