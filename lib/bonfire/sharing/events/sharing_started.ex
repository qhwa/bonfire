defmodule Bonfire.Sharing.Events.SharingStarted do
  @derive Jason.Encoder
  @enforce_keys [:user_id, :key]
  defstruct [:user_id, :key]
end
