defmodule Bonfire.Tracks.Projectors.ReadingState do
  use Commanded.Projections.Ecto,
    application: Bonfire.Tracks.EventApp,
    repo: Bonfire.Repo,
    name: "reading_state_projection"
end
