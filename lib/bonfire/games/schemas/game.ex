defmodule Bonfire.Games.Schemas.Game do
  @moduledoc """
  An Ecto schema for games.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :star_count_in_current_season, :integer
    field :star_count_in_total, :integer

    belongs_to :user, Bonfire.Users.User

    timestamps()
  end

  @doc false
  def updating_changeset(game, attrs) do
    game
    |> cast(attrs, [:star_count_in_current_season, :star_count_in_total])
  end
end
