defmodule IsbnId do
  @derive Jason.Encoder
  @enforce_keys [:isbn, :user_id]
  defstruct [:isbn, :user_id]

  defimpl String.Chars do
    def to_string(%IsbnId{isbn: isbn, user_id: user_id}) do
      [user_id, isbn] |> Enum.join(":")
    end
  end
end
