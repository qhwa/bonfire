defmodule Bonfire.Games.Commands.NewStar do
  @moduledoc """
  A struct module for the command to give user new star(s)
  """
  @type t() :: %__MODULE__{user_id: any}

  @enforce_keys [:user_id]
  defstruct user_id: nil, amount: 1, source: nil, prev_star_count: nil
end
