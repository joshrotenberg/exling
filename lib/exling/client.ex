defmodule Exling.Client do
  @type request :: Exling.Request 
  @type opts :: [term, ...]
  @callback receive(request, opts) :: any
end

if Code.ensure_loaded?(HTTPoison) do
  defmodule Exling.Client.HTTPoison do
    @behaviour Exling.Client
    def receive(request, options) do
      HTTPoison.request(request.method, URI.to_string(request.uri), request.body, request.headers, options)
    end
  end
end

if Code.ensure_loaded?(:hackney) do
  defmodule Exling.Client.Hackney do
    @behaviour Exling.Client
    def receive(request, options) do
      :hackney.request(request.method, URI.to_string(request.uri), request.headers, request.body, options)
    end
  end
end

if Code.ensure_loaded?(HTTPotion) do
  defmodule Exling.Client.HTTPotion do
    @behaviour Exling.Client
    def receive(request, opts) do
      HTTPotion.request(request.method, URI.to_string(request.uri), [body: request.body, headers: request.headers] ++ opts)
    end
  end
end

if Code.ensure_loaded?(:ibrowse) do
  defmodule Exling.Client.Ibrowse do
    @behaviour Exling.Client
    def receive(request, options) do
      :ibrowse.send_req(URI.to_string(request.uri) |> to_char_list, request.headers, request.method, request.body, options)
    end
  end
end



