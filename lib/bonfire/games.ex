defmodule Bonfire.Games do
  @moduledoc """
  Gaming related high level APIs.
  """

  alias Bonfire.{
    EventApp,
    Games.Commands.StartGame,
    Games.Schemas.Game,
    Repo
  }

  import Ecto.Query, only: [from: 2]

  @doc """
  Start a game for a user
  """
  def start_game(%{id: user_id}), do: start_game(user_id)
  def start_game(user_id), do: EventApp.dispatch(%StartGame{user_id: user_id})

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
