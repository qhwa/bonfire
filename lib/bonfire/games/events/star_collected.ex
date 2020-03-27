defmodule Bonfire.Games.Events.StarCollected do
  @moduledoc """
  A struct module for star(s) collected events.
  """

  @type t() :: %__MODULE__{
          user_id: any,
          amount: pos_integer,
          source: nil | list,
          prev_star_count: non_neg_integer
        }

  @derive Jason.Encoder

  @enforce_keys [:user_id, :amount]
  defstruct [:user_id, :amount, :source, :prev_star_count]
end
