defmodule Bonfire.Core.Track do
  @moduledoc """
  This module represents the reading track of a book.
  Tracks belong to users, while books are not.
  We can think books as templates of tracks, and tracks
  as instances of books
  """

  @enforce_keys [:book]

  defstruct book: nil,
            reader: nil,
            progress: nil,
            notes: [],
            state: nil,
            at_page: nil,
            feeling: nil
end
