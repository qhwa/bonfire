defmodule Util.Term do
  @moduledoc """
  Raw Erlang/Elixir term to be stored in database.
  """
  @behaviour Ecto.Type

  def type, do: :binary
  def cast(bin), do: load(bin)
  def load(bin), do: {:ok, bin |> :erlang.binary_to_term()}
  def dump(bin), do: {:ok, bin |> :erlang.term_to_binary()}
end
