defmodule BonfireWeb.Live.Push do
  @moduledoc """
  Live push display.
  """

  use Phoenix.HTML
  use Phoenix.LiveView
  alias BonfireWeb.PushView

  def render(assigns) do
    PushView.render("show.html", assigns)
  end

  def mount(_params, %{"user" => user}, socket) do
    Phoenix.PubSub.subscribe(Bonfire.PubSub, topic(user.id), link: true)

    socket =
      socket
      |> assign(:push, Bonfire.Pushes.latest_push(user))

    {:ok, socket}
  end

  defp topic(user_id), do: "push:#{user_id}"

  def handle_info({_, :push_created, push}, socket) do
    {:noreply, assign(socket, :push, push)}
  end

  def handle_info({_, :push_read, push}, socket) do
    if push == socket.assigns.push do
      {:noreply, assign(socket, :push, nil)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("ok", %{"redirect" => path}, socket) do
    push = socket.assigns.push
    Bonfire.Pushes.read(push)

    socket =
      socket
      |> assign(:push, nil)
      |> redirect(to: path)

    {:noreply, socket}
  end

  def handle_event("ok", _, socket) do
    push = socket.assigns.push
    Bonfire.Pushes.read(push)

    {:noreply, assign(socket, :push, nil)}
  end

  def handle_event("no", _, socket) do
    push = socket.assigns.push
    Bonfire.Pushes.read(push)

    {:noreply, assign(socket, :push, nil)}
  end

  def handle_event("dismiss", _, socket) do
    {:noreply, assign(socket, :push, nil)}
  end
end
