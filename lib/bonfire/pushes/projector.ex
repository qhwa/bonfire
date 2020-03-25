defmodule Bonfire.Pushes.Projector do
  @moduledoc false

  use Commanded.Projections.Ecto,
    application: Bonfire.EventApp,
    repo: Bonfire.Repo,
    name: "push_projection"

  alias Bonfire.Pushes.{
    Schemas.Push,
    Events.PushCreated
  }

  project(%PushCreated{uuid: uuid, user_id: user_id, content: content}, _, fn multi ->
    push = %Push{
      id: uuid,
      state: "created",
      user_id: user_id,
      content: Bonfire.Pushes.render_content(content)
    }

    ret =
      Ecto.Multi.insert(
        multi,
        :new_push,
        push
      )

    Phoenix.PubSub.broadcast(
      Bonfire.PubSub,
      "push:#{user_id}",
      {__MODULE__, :push, push}
    )

    ret
  end)
end
