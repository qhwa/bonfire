defmodule Bonfire.Pushes.Events.PushCreated do
  @moduledoc "A struct representing push created event"
  @derive Jason.Encoder
  @enforce_keys [:id, :user_id]
  defstruct [:id, :user_id, :content]
end
