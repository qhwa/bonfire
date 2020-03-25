defmodule Bonfire.Games.Rule do
  @moduledoc """
  Behaviour module for rules.
  """
  alias Bonfire.Games.GameState

  @doc """
  Apply with a game state object and an event, returning
  the commands to perform.
  """
  @callback apply(%GameState{}, struct) :: list(struct)
end
