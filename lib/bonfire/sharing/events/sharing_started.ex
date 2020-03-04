defmodule Bonfire.Sharing.Events.SharingStarted do
  @moduledoc """
  Event struct
  """

  @type t :: %__MODULE__{user_id: any, key: binary}

  @derive Jason.Encoder
  @enforce_keys [:user_id, :key]
  defstruct [:user_id, :key]
end
