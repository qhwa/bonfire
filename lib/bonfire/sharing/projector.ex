defmodule Bonfire.Sharing.Projector do
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

  require Logger

  project(%SharingStarted{user_id: user_id, key: key}, _metadata, fn multi ->
    Ecto.Multi.insert(
      multi,
      :creat_track_sharing,
      Profile.creating_changeset(%Profile{}, %{user_id: user_id, share_key: key}),
      on_conflict: [set: [share_key: key]],
      conflict_target: [:user_id]
    )
  end)

  def error({:error, %Ecto.Changeset{valid?: false} = error}, _event, _failure_context) do
    Logger.error(["Failed processing SharingStarted event due to error: ", inspect(error)])
    :skip
  end
end
