defmodule Bonfire.Books.DoubanBookApi do
  use HTTPoison.Base

  def get_book_cover(isbn) do
    get!(isbn)
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("cover_url")
  end

  def process_request_url(isbn) do
    "https://book.feelyou.top/isbn/#{URI.encode(isbn)})"
  end

  def process_request_options(_) do
    proxy =
      Application.get_env(:bonfire, __MODULE__)
      |> get_in([:proxy])
      |> ParseProxy.parse!()

    [proxy: proxy]
  end
end
