defmodule BonfireWeb.Live.SharingView do
  @moduledoc false

  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(BonfireWeb.SharingView, "new.html", assigns)
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    socket =
      socket
      |> assign_share_key(user_id)
      |> assign(:user_id, user_id)

    {:ok, socket}
  end

  defp assign_share_key(socket, user_id) do
    case Bonfire.Sharing.get_share_key(user_id) do
      key when is_binary(key) ->
        socket
        |> assign(:share_key, key)
        |> assign(:share_url, BonfireWeb.Router.Helpers.profile_url(socket, :show, key))

      _ ->
        nil
    end
  end

  def handle_event("save", %{"key" => key}, socket) do
    user_id = socket.assigns.user_id

    :ok = Bonfire.Sharing.start_sharing(user_id, key)

    {:noreply, assign_share_key(socket, user_id)}
  end
end
