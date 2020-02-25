defmodule BonfireWeb.ReadingStateView do
  use BonfireWeb, :view

  def state_label("pending"), do: {:safe, "<span>planned</span>"}
  def state_label("started"), do: {:safe, "<span>reading</span>"}
  def state_label(o), do: o
end
