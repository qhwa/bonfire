defmodule Bonfire.Games.Commands.StartGame do
  @moduledoc """
  A struct module for "start game" command
  """
  @type t() :: %__MODULE__{user_id: any}

  @enforce_keys [:user_id]
  defstruct [:user_id]
end
