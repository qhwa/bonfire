defmodule Bonfire.Pushes.Events.PushRead do
  @moduledoc "A struct representing push read event"
  @derive Jason.Encoder
  @enforce_keys [:id, :user_id]
  defstruct [:id, :user_id]
end
