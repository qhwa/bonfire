defmodule Bonfire.Repo.Migrations.CreateReadingStates do
  use Ecto.Migration

  def change do
    create table(:reading_states) do
      add :state, :string
      add :started_at, :utc_datetime
      add :finished_at, :utc_datetime
      add :book_id, references(:books, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:reading_states, [:book_id])
    create index(:reading_states, [:state])
    create index(:reading_states, [:updated_at])
  end
end
