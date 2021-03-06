defmodule TrackId do
  @moduledoc """
  A struct holding the `isbn`, and `user_id`. The struct often used as a context.
  """
  @type t :: %{isbn: binary, user_id: any}

  @derive Jason.Encoder
  @enforce_keys [:isbn, :user_id]
  defstruct [:isbn, :user_id]

  defimpl String.Chars do
    def to_string(%TrackId{isbn: isbn, user_id: user_id}) do
      [user_id, isbn] |> Enum.join(":")
    end
  end
end
