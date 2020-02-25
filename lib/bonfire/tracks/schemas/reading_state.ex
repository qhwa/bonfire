defmodule Bonfire.Tracks.Schemas.ReadingState do
  use Ecto.Schema

  schema "reading_states" do
    field :finished_at, :utc_datetime
    field :started_at, :utc_datetime
    field :state, :string

    belongs_to :book, Bonfire.Books.Book

    timestamps()
  end
end
