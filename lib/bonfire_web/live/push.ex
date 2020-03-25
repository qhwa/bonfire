defmodule BonfireWeb.Live.Push do
  @moduledoc """
  Live push display.
  """

  use Phoenix.HTML
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <%= if @push do %>
      <div class="modal is-active">
        <div class="modal-background"></div>
        <div class="modal-content">
          <div class="card">
            <div class="card-content">
              <%= @push.content %>
            </div>
            <div class="card-footer">
              <a href="#" phx-click="read" class="card-footer-item">Got it</a>
            </div>
          </div>
        </div>
        <button class="modal-close is-large" aria-label="close" phx-click="dismiss"></button>
      </div>
    <% end %>
    """
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

  def handle_event("read", _, socket) do
    push = socket.assigns.push
    Bonfire.Pushes.read(push)

    {:noreply, assign(socket, :push, nil)}
  end

  def handle_event("dismiss", _, socket) do
    {:noreply, assign(socket, :push, nil)}
  end
end
