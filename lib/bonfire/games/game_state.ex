defmodule Bonfire.Games.GameState do
  @moduledoc """
  A struct module representing game states for users.
  """
  @enforce_keys [:user_id]

  defstruct user_id: nil, star_count_in_current_season: 0, star_count_in_total: 0
end
