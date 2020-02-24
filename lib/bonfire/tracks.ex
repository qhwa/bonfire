defmodule Bonfire.Tracks do
  @moduledoc """
  Tracks context. This module holds tracking related high level API.
  """

  alias Bonfire.Core.Book
  alias Bonfire.Core
  alias Bonfire.Tracks.TrackServer

  def start_reading(book_id) do
    with {:ok, book} = Book.load(book_id),
         {:ok, track} = Core.start_reading(book),
         {:ok, server} = TrackServer.track_server(book_id) do
      TrackServer.update_track(server, track)
    end
  end
end
