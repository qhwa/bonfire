defmodule Bonfire.Games.Events.GameStarted do
  @moduledoc """
  A struct module for "game started" events.
  """

  @type t() :: %__MODULE__{user_id: any}

  @derive Jason.Encoder

  @enforce_keys [:user_id]
  defstruct [:user_id]
end
