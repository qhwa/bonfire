defmodule Bonfire.Books.DoubanBookApi do
  use HTTPoison.Base
  require Logger

  def get_book_cover(isbn) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- get(isbn),
         {:ok, data} <- Jason.decode(body) do
      Map.get(data, "cover_url")
    else
      e ->
        Logger.error(["error getting cover from douban, ", inspect(e)])
        nil
    end
  end

  def process_request_url(isbn) do
    "https://book.feelyou.top/isbn/#{URI.encode(isbn)})"
  end

  def process_request_options(_) do
    Application.get_env(:bonfire, __MODULE__)
    |> get_in([:proxy])
    |> ParseProxy.parse!()
  end
end
