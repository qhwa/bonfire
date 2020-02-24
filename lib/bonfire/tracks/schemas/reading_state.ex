defmodule Bonfire.Tracks.Schemas.ReadingState do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reading_states" do
    field :finished_at, :utc_datetime
    field :started_at, :utc_datetime
    field :state, :string

    belongs_to :book, Bonfire.Books.Book

    timestamps()
  end

  @doc false
  def changeset(reading_state, attrs) do
    reading_state
    |> cast(attrs, [:state, :started_at, :finished_at])
    |> validate_required([:state])
  end
end
