defmodule Bonfire.Sharing.Commands.StartSharing do
  @enforce_keys [:user_id, :key]

  defstruct [:user_id, :key]
end
