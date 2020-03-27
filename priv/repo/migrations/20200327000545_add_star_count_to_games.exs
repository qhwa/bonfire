defmodule Bonfire.Repo.Migrations.AddStarCountToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :star_count_in_current_season, :integer, default: 0
      add :star_count_in_total, :integer, default: 0
    end

    create index(:games, [:star_count_in_current_season])
    create index(:games, [:star_count_in_total])
  end
end
