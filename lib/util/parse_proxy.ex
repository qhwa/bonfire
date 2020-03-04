defmodule ParseProxy do
  def parse!(nil), do: nil

  def parse!(url) do
    case URI.parse(url) do
      %{host: host, port: port, scheme: scheme} ->
        {String.to_atom(scheme), String.to_charlist(host), port}

      _ ->
        raise "invalid proxy setting: #{inspect(url)}"
    end
  end
end
