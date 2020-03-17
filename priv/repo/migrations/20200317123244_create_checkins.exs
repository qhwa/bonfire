defmodule Bonfire.Repo.Migrations.CreateCheckins do
  use Ecto.Migration

  def change do
    create table(:checkins) do
      add :date, :date
      add :insight, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :reading_state_id, references(:reading_states, on_delete: :nothing)

      timestamps()
    end

    create index(:checkins, [:user_id])
    create index(:checkins, [:reading_state_id])
    create index(:checkins, [:date])
  end
end
