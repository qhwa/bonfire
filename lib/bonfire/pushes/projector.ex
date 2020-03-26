defmodule Bonfire.Pushes.Projector do
  @moduledoc false

  use Commanded.Projections.Ecto,
    application: Bonfire.EventApp,
    repo: Bonfire.Repo,
    name: "push_projection"

  alias Bonfire.Pushes.{
    Schemas.Push,
    Events.PushCreated,
    Events.PushRead
  }

  project(%PushCreated{content: content, user_id: user_id} = evt, _, fn multi ->
    push = Push.from_event(%{evt | content: Bonfire.Pushes.render_content(content)})

    ret =
      Ecto.Multi.insert(
        multi,
        :new_push,
        push
      )

    Phoenix.PubSub.broadcast(
      Bonfire.PubSub,
      "push:#{user_id}",
      {__MODULE__, :push_created, push}
    )

    ret
  end)

  project(%PushRead{id: id, user_id: user_id}, _, fn multi ->
    push = Bonfire.Repo.get(Push, id)

    change =
      push
      |> Push.read_changeset()

    ret =
      Ecto.Multi.update(
        multi,
        :read_push,
        change
      )

    Phoenix.PubSub.broadcast(
      Bonfire.PubSub,
      "push:#{user_id}",
      {__MODULE__, :push_read, push}
    )

    ret
  end)
end
