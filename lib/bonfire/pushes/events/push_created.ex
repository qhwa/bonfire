defmodule Bonfire.Pushes.Events.PushCreated do
  @moduledoc "A struct representing push created event"
  @derive Jason.Encoder
  @enforce_keys [:uuid, :user_id]
  defstruct [:uuid, :user_id, :content]
end
