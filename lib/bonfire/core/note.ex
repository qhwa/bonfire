defmodule Bonfire.Core.Note do
  @moduledoc """
  This module represents notes taken about a book.
  """

  defstruct [:content, :at]

  def new(content) when is_binary(content) do
    %__MODULE__{content: content, at: DateTime.utc_now()}
  end

  def new(%__MODULE__{} = note) do
    note
  end

  def new(_) do
    raise ArgumentError, "Argument must be a string or a Note struct"
  end
end
