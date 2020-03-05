defmodule Bonfire.Sharing.Projectors.Track do
  @moduledoc """
  A projector with hooks on sharing changes.
  """

  use Commanded.Projections.Ecto,
    application: Bonfire.EventApp,
    repo: Bonfire.Repo,
    name: "sharing_track_projection"

  alias Bonfire.Sharing.{
    Events.SharingStarted,
    Profile
  }

  project(%SharingStarted{user_id: user_id, key: key}, _metadata, fn multi ->
    Ecto.Multi.insert(
      multi,
      :creat_track_sharing,
      Profile.creating_changeset(%Profile{}, %{user_id: user_id, share_key: key})
    )
  end)
end
