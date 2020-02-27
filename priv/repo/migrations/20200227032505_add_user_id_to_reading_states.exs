defmodule Bonfire.Repo.Migrations.AddUserIdToReadingStates do
  use Ecto.Migration

  def change do
    alter table(:reading_states) do
      add :user_id, references(:users)
    end
  end
end
