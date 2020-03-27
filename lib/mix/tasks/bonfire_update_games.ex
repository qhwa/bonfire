defmodule Mix.Tasks.Bonfire.UpdateGames do
  @moduledoc """
  A task to update all game scores.

  Usage:

  mix bonfire.update_games
  """
  alias Bonfire.{
    Repo,
    Users.User,
    Games
  }

  def run(_) do
    Application.ensure_all_started(:bonfire)

    Repo.all(User)
    |> Repo.preload(:game)
    |> Enum.each(&Games.update_game(&1.game))
  end
end
