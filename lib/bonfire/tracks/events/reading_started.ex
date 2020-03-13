defmodule Bonfire.Tracks.Events.ReadingStarted do
  @moduledoc """
  Reading started event struct.
  """

  @derive Jason.Encoder

  @type t :: %{track_id: TrackId.t()}

  defstruct [:track_id]
end
