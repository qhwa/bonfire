defmodule Bonfire.Auth.HTTP do
  @moduledoc false

  @behaviour Assent.HTTPAdapter

  @impl true
  def request(method, url, body, headers, opts) do
    opts =
      default_options()
      |> Keyword.merge(opts || [])

    headers = [{"Accept", "application/json"} | headers]

    with {:ok, res} <- HTTPoison.request(method, url, body || "", headers, opts) do
      {:ok,
       %Assent.HTTPAdapter.HTTPResponse{
         status: res.status_code,
         headers: res.headers,
         body: Jason.decode!(res.body |> IO.inspect())
       }}
    end
  end

  defp default_options do
    Application.get_env(:bonfire, __MODULE__)
    |> get_in([:proxy])
    |> ParseProxy.parse!()
  end
end
