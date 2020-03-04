defmodule Bonfire.Tracks.Events.ReadingFinished do
  @moduledoc """
  Reading finished event struct.
  """

  @type t :: %{isbn: IsbnId.t()}

  @derive Jason.Encoder

  defstruct [:isbn]
end
