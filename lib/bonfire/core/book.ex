defmodule Bonfire.Core.Book do
  @moduledoc """
  This module reprensents the data struct of books.
  """

  @enforce_keys [:title]

  defstruct [:isbn, :title, :author, :description, :cover, :tags]
end
