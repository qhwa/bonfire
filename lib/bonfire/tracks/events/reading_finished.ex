defmodule Bonfire.Tracks.Events.ReadingFinished do
  @moduledoc """
  Reading finished event struct.
  """

  @type t :: %{track_id: TrackId.t()}

  @derive Jason.Encoder

  defstruct [:track_id]
end
