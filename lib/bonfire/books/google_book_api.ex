defmodule Bonfire.Books.GoogleBookAPI do
  use HTTPoison.Base

  @endpoint "https://www.googleapis.com/books/v1/volumes"

  def search_books(keyword) do
    get!(@endpoint, [], params: [q: keyword])
    |> Map.get(:body)
    |> case do
      books when is_list(books) ->
        books

      _ ->
        []
    end
  end

  def find_book_by_isbn(isbn) do
    search_books(isbn)
    |> Enum.find(fn book -> book.isbn == isbn end)
    |> case do
      %{} = book -> {:ok, book}
      nil -> nil
    end
  end

  def process_request_options(options) do
    Keyword.merge(default_options(), options)
  end

  defp default_options do
    proxy =
      Application.get_env(:bonfire, __MODULE__)
      |> get_in([:proxy])
      |> ParseProxy.parse!()

    [proxy: proxy]
  end

  def process_request_params(params) do
    Keyword.put(params, :key, api_key())
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
    end
  end

  @keys ~w[title subtitle authors description publisher]

  defp transform_book_data(%{"volumeInfo" => info, "id" => id}) do
    data = %{
      cover: cover_image(info) |> to_ssl(),
      thumbnail: thumbnail(info) |> to_ssl(),
      isbn: isbn(info),
      source_platform: "google",
      source_id: id
    }

    for key <- @keys, into: data do
      {String.to_atom(key), info[key]}
    end
  end

  defp isbn(%{"industryIdentifiers" => raw_isbn_info}) do
    Enum.find_value(raw_isbn_info, fn
      %{"type" => "ISBN_13", "identifier" => id} ->
        id

      _ ->
        false
    end)
  end

  defp isbn(_) do
    nil
  end

  defp cover_image(%{"imageLinks" => %{} = links}) do
    links["extraLarge"] || links["large"] || links["medium"] || links["thumbnail"]
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

  defp to_ssl(url) when is_binary(url) do
    String.replace_prefix(url, "http://", "https://")
  end

  defp to_ssl(_) do
    nil
  end
end
