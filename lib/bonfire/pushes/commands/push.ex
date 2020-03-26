defmodule Bonfire.Pushes.Commands.Push do
  @moduledoc "A struct representing the push command to users"
  @derive Jason.Encoder
  @enforce_keys [:user_id, :content]
  defstruct [:user_id, :content, :actions, :allow_dismiss]
end
