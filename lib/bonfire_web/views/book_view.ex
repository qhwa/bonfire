defmodule BonfireWeb.BookView do
  use BonfireWeb, :view

  def cover_tag(nil) do
    content_tag(:div, "", class: "book-cover")
  end

  def cover_tag(thumbnail) do
    content_tag(:div, "", class: "book-cover", style: "background-image: url(#{thumbnail})")
  end
end
