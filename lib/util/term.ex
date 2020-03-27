defmodule Util.Term do
  @moduledoc """
  Raw Erlang/Elixir term to be stored in database.
  """
  @behaviour Ecto.Type

  def type, do: :binary
  def cast(bin), do: load(bin)
  def load(bin), do: {:ok, bin |> :erlang.binary_to_term()}

  def embed_as(_), do: :dump
  def dump(term), do: {:ok, term |> :erlang.term_to_binary()}
  def equal?(term, term), do: true
  def equal?(_, _), do: false
end
