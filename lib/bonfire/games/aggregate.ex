defmodule Bonfire.Games.Aggregate do
  @moduledoc """
  An aggregate for gaming commands.
  """

  alias Bonfire.Games.{
    Commands.StartGame,
    Commands.NewStar,
    Events.GameStarted,
    Events.StarCollected,
    GameState
  }

  defstruct [:user_id, :game]

  def execute(%__MODULE__{user_id: nil}, %StartGame{user_id: user_id}) do
    %GameStarted{user_id: user_id}
  end

  def execute(_, %StartGame{}) do
    {:error, :game_already_started}
  end

  def execute(nil, %NewStar{} = cmd) do
    %{cmd | __struct__: StarCollected}
  end

  def execute(%{game: %{star_count_in_total: count}}, %NewStar{} = cmd) do
    %{cmd | __struct__: StarCollected, prev_star_count: count}
  end

  def apply(_, %GameStarted{user_id: user_id}) do
    %__MODULE__{user_id: user_id, game: %GameState{user_id: user_id}}
  end

  def apply(%{game: game} = state, %StarCollected{amount: amount}) do
    game =
      game
      |> Map.update!(:star_count_in_current_season, &(&1 + amount))
      |> Map.update!(:star_count_in_total, &(&1 + amount))

    %{state | game: game}
  end
end
