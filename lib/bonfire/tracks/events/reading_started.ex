defmodule Bonfire.Tracks.Events.ReadingStarted do
  @moduledoc """
  Reading started event struct.
  """

  @derive Jason.Encoder

  @type t :: %{isbn: IsbnId.t()}

  defstruct [:isbn]
end
