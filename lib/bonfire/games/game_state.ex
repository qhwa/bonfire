defmodule Bonfire.Games.GameState do
  @moduledoc """
  A struct module representing game states for users.
  """
  @enforce_keys [:user_id]

  defstruct user_id: nil, score: 0
end
