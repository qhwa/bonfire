defmodule Bonfire.Pushes.Commands.Read do
  @moduledoc "A commanded command, representing reading a push."
  @derive Jason.Encoder
  @enforce_keys [:user_id, :id]
  defstruct [:user_id, :id]
end
