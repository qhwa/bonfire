defmodule Bonfire.Events.ReadingStarted do
  @derive Jason.Encoder

  defstruct [:book_id, :started_at]
end
