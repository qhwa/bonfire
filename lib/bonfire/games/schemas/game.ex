defmodule Bonfire.Games.Schemas.Game do
  @moduledoc """
  An Ecto schema for games.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    belongs_to :user, Bonfire.Users.User

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [])
    |> validate_required([])
    |> unique_constraint(:user_id)
  end
end
