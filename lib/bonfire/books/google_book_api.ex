defmodule Bonfire.Books.GoogleBookAPI do
  use HTTPoison.Base

  @endpoint "https://www.googleapis.com/books/v1/volumes"
  @api_key System.fetch_env!("GOOGLE_API_KEY")

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

  def find_book(query) do
    get!(@endpoint, [], params: [q: stringify_query(query)])
    |> Map.get(:body)
    |> case do
      books when is_list(books) ->
        {:ok, hd(books)}

      other ->
        other
    end
  end

  defp stringify_query(query) do
    query
    |> Enum.map(fn
      {key, value} ->
        [to_string(key), ":", to_string(value)]

      term when is_binary(term) ->
        term
    end)
    |> Enum.intersperse("+")
    |> IO.iodata_to_binary()
  end

  def process_request_options(options) do
    Keyword.merge(default_options(), options)
  end

  defp default_options do
    Application.get_env(:bonfire, __MODULE__)
    |> Keyword.get(:request_options)
  end

  def process_request_params(params) do
    Keyword.put(params, :key, @api_key)
  end

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

  defp transform_book_data(%{"volumeInfo" => info, "id" => id}) do
    data = %{
      isbn: isbn(info),
      source_platform: "google",
      source_id: id
    }

    for key <- ~w[title subtitle authors description], into: data do
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
end
