defmodule Bonfire.Repo.Migrations.AddUserIdToBooks do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :user_id, references(:users)
    end

    drop unique_index(:books, [:metadata_id])
    create unique_index(:books, [:user_id, :metadata_id])
  end
end
