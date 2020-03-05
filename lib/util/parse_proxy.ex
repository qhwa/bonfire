defmodule ParseProxy do
  @moduledoc """
  A utility tool for parsing proxy config from string to Erlang term.

  ## Example:

    iex> ParseProxy.parse!("socks5://example.com:1234")
    [proxy: {:socks5, 'example.com', 1234}]

    iex> ParseProxy.parse!("socks5://user:secret@example.com:1234")
    [proxy: {:socks5, 'example.com', 1234}, proxy_auth: {'user', 'secret'}]

    iex> ParseProxy.parse!("http://example.com:1234")
    [proxy: {:http, 'example.com', 1234}]

    iex> ParseProxy.parse!(nil)
    []

  Authe
  """
  def parse!(nil), do: []

  def parse!(url) when is_binary(url),
    do: url |> URI.parse() |> parse!()

  def parse!(%{host: nil}),
    do: []

  def parse!(%{host: host, port: port, scheme: scheme, userinfo: nil}),
    do: [proxy: {String.to_atom(scheme), String.to_charlist(host), port}]

  def parse!(%{userinfo: userinfo} = uri),
    do: parse!(%{uri | userinfo: nil}) ++ [proxy_auth: parse_auth(userinfo)]

  defp parse_auth(userinfo) do
    userinfo
    |> String.split(":")
    |> Enum.map(&String.to_charlist/1)
    |> List.to_tuple()
  end
end
