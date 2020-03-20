defmodule Bonfire.Books.GoogleBookAPI do
  @moduledoc false

  use HTTPoison.Base
  require Logger

  @endpoint "https://www.googleapis.com/books/v1/volumes"

  def search_books(keyword) do
    get!(@endpoint, [], params: %{q: keyword})
    |> Map.get(:body)
    |> case do
      books when is_list(books) ->
        books

      other ->
        Logger.error(["Search failed,\n  keyword: ", keyword, "\n  result: ", inspect(other)])
        []
    end
  end

  def find_book_by_isbn(isbn) do
    search_books("isbn:#{isbn}")
    |> Enum.find(fn book -> book.isbn == isbn end)
    |> case do
      %{} = book -> {:ok, book}
      nil -> {:error, :not_found}
    end
  end

  def find_book_by_id(id) do
    Path.join(@endpoint, id)
    |> get!()
    |> Map.get(:body)
  end

  def process_request_options(options) do
    Keyword.merge(default_options(), options)
  end

  defp default_options do
    Application.get_env(:bonfire, __MODULE__)
    |> get_in([:proxy])
    |> ParseProxy.parse!()
  end

  def process_request_params(params) do
    Map.put(params, :key, api_key())
  end

  defp api_key, do: System.fetch_env!("GOOGLE_API_KEY")

  def process_response_body(body) do
    body
    |> Jason.decode!()
    |> case do
      %{"error" => error} ->
        {:error, {:request_error, error}}

      %{"totalItems" => 0} ->
        {:error, :not_found}

      %{"items" => items} ->
        Enum.map(items, &transform_book_data/1)

      %{"volumeInfo" => _} = info ->
        transform_book_data(info)
    end
  end

  @keys ~w[title subtitle authors description publisher categories]

  defp transform_book_data(%{"volumeInfo" => info, "id" => id}) do
    isbn_10 = isbn(info, "ISBN_10")
    isbn_13 = isbn(info, "ISBN_13")

    data = %{
      cover: cover_image(info) |> transform_cover_url(),
      thumbnail: thumbnail(info) |> transform_cover_url(),
      isbn_10: isbn_10,
      isbn_13: isbn_13,
      isbn: isbn_13 || isbn_10,
      source_platform: "google",
      source_id: id
    }

    for key <- @keys, into: data do
      {String.to_atom(key), info[key]}
    end
  end

  defp isbn(%{"industryIdentifiers" => raw_isbn_info}, key) do
    Enum.find_value(raw_isbn_info, fn
      %{"type" => ^key, "identifier" => id} ->
        id

      _ ->
        false
    end)
  end

  defp isbn(_, _) do
    nil
  end

  defp cover_image(%{"imageLinks" => %{} = links}) do
    links["extraLarge"] || links["large"] || links["medium"] || links["thumbnail"] ||
      links["smallThumbnail"]
  end

  defp cover_image(_) do
    nil
  end

  defp thumbnail(%{"imageLinks" => %{} = links}) do
    links["smallThumbnail"] || links["thumbnail"]
  end

  defp thumbnail(_) do
    nil
  end

  defp transform_cover_url(url) when is_binary(url) do
    url
    |> String.replace_prefix("http://", "https://")
    |> String.replace("&edge=curl", "")
  end

  defp transform_cover_url(_) do
    nil
  end
end
