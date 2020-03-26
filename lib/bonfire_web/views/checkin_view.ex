defmodule BonfireWeb.CheckinView do
  use BonfireWeb, :view

  def frequency([]), do: nil
  def frequency(checkins) when length(checkins) == 1, do: "once"
  def frequency(checkins) when length(checkins) == 2, do: "a-few"
  def frequency(_), do: "a-lot"

  def week_title(1), do: "this week"
  def week_title(2), do: "last week"
  def week_title(ago), do: "#{ago - 1} weeks ago"

  def datetime_tag(%Plug.Conn{assigns: %{current_user: %{profile: %{timezone: tz}}}}, datetime) do
    datetime_tag(tz, datetime)
  end

  def datetime_tag(tz, datetime) when is_binary(tz) do
    dt = Bonfire.Tracks.db_time_to_user_time(datetime, tz)
    content_tag(:span, to_str(dt))
  end

  def datetime_tag(_, datetime) do
    content_tag(:span, to_str(datetime))
  end

  defp to_str(dt) do
    [dt.year, "-", dt.month, "-", dt.day, " ", dt.hour, ":", dt.minute, ":", dt.second]
    |> Enum.map(fn
      x when is_integer(x) and x < 10 ->
        "0" <> to_string(x)

      o ->
        o
    end)
    |> Enum.join()
  end

  @doc """
  Render insight text of a checkin, with markdown transformed to HTML.
  """
  def insight(text) do
    case Earmark.as_html(text) do
      {:ok, html, _} ->
        {:safe, html}

      {:error, html, _} ->
        {:safe, html}
    end
  end
end
