defmodule Bonfire.Sharing.Commands.StartSharing do
  @moduledoc """
  A command struct, to start sharing reading tracks. 
  """

  @type t :: %__MODULE__{user_id: any, key: binary}

  @enforce_keys [:user_id, :key]

  defstruct [:user_id, :key]
end
