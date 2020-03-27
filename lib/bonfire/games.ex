defmodule Bonfire.Games do
  @moduledoc """
  Gaming related high level APIs.
  """

  alias Bonfire.{
    EventApp,
    Tracks.Schemas.Checkin,
    Games.Commands.StartGame,
    Games.Leaderboard,
    Games.Schemas.Game,
    Repo
  }

  import Ecto.Query, only: [from: 2]

  @doc """
  Start a game for a user
  """
  def start_game(%{id: user_id}), do: start_game(user_id)
  def start_game(user_id), do: EventApp.dispatch(%StartGame{user_id: user_id})

  def update_game(%Game{user_id: user_id} = game) do
    count =
      from(c in Checkin, where: c.user_id == ^user_id)
      |> Repo.aggregate(:count)

    Game.updating_changeset(game, %{
      star_count_in_current_season: count,
      star_count_in_total: count
    })
    |> Repo.update()
  end

  @doc """
  Get top 10 games ordered by start count in this season.
  """
  def top_games do
    from(
      g in Game,
      limit: 10,
      order_by: [desc: :star_count_in_current_season],
      where: g.star_count_in_current_season > 0
    )
    |> Repo.all()
    |> Repo.preload(user: :profile)
  end
end
