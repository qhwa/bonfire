defmodule Bonfire.Games.Aggregate do
  @moduledoc """
  An aggregate for gaming commands.
  """

  alias Bonfire.Games.{
    Commands.StartGame,
    Events.GameStarted
  }

  defstruct [:user_id]

  def execute(%__MODULE__{user_id: nil}, %StartGame{user_id: user_id}) do
    %GameStarted{user_id: user_id}
  end

  def execute(_, %StartGame{}) do
    {:error, :game_already_started}
  end

  def apply(_, %GameStarted{user_id: user_id}) do
    %__MODULE__{user_id: user_id}
  end
end
