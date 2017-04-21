defmodule Exling do
  @moduledoc """
  Exling is a fluent HTTP request builder and executor for Elixir. It is
  intended to make it simpler to build HTTP client APIs, but should be handy
  any time you need to make an HTTP request. It isn't an HTTTP client library,
  however, and leaves the actual request and response handling up to already
  established HTTP libraries.

  Exling strives to be a simple, intuitive way to encapsulate API interaction with
  clear and minimal code that can be built upon and easily extended. Using Elixir's
  pipe operator, the developer can clearly define an API request's URI, headers, body,
  and method. It makes reasonable
  assumptions (such as setting the content type for you when possible) while not
  making it difficult to override these assumptions, and extending the interface should
  be trivial by manipulating the `Exling.Request` yourself with your own custom functions.

      {:ok, response} = Exling.new |>
            Exling.base("http://some.api.io") |>
            Exling.post("thing") |>
            Exling.body(%{args: "here"}, :json) |>
            Exling.receive()
  """

  @supported_client_modules [HTTPoison, HTTPotion, :hackney, :ibrowse]
  @default_client_module HTTPoison

  @doc """
  Returns a new `Exling.Request`. 

      # a new, empty request
      r = Exling.new 
  """
  def new() do
    client = case Application.get_env(:exling, :client) do
      nil -> @default_client_module
      configured_client -> configured_client
    end
    %{%Exling.Request{} | uri: URI.parse(""), client: client}
  end
  
  @doc """
  Returns a new Exling.Request with base URI configured.

      # a request with our base URI already configured
      r = Exling.new("http://some.api.io/stuff")
  """
  def new(base_uri) do
    new() |> base(base_uri)
  end

  @doc """
  Set the client module for a predefined request handling backend. Supported options are 
  `HTTPoison` (default), `HTTPotion`, `:hackney`, or `:ibrowse`. Or, set the client to a one or two
  arity function for custom impementations. A single arity function will just get the request, a double
  will also get the options passed to `receive`. The function will be called with the `Exling.Request` 
  struct along with any options (see `receive`).
  """
  def client(request, f) when is_function(f, 1) or is_function(f, 2), do: %{request | client: f}
  def client(request, client_module) do 
    if !Enum.member?(@supported_client_modules, client_module) do
      raise "'#{client_module}' isn't a recognized client implementation"
    end
    case Code.ensure_loaded(client_module) do
      {:module, module_name} -> %{request | client: module_name}
      {:error, :nofile} -> raise "'#{client_module} isn't available, did you add it to `deps`?"
    end
  end

  @doc """
  Set the base URI (or really as much URI information as you want).

      r = Exling.new |> 
        Exling.base("http://example.com")

      r = Exling.new |>
        Exling.base("http://something.else.com/with/more/path")
  """
  def base(request, base_uri), do: %{request | uri: URI.parse(base_uri)}

  @doc """
  Set the URI path. Exling will try to figure out slashes for you so a leading
  slash is optional. Can be called multiple times to append path elements.

      # this request points at http://exampl.com/some/path
      r = Exling.new |>
        Exling.base("http://example.com") |>
        Exling.path("/some/path")

      # and so does this one
      r = Exling.new("http://example.com") |>
        Exling.path("some") |>
        Exling.path("path")

      # and so does this one (see docs for setting the method)
      r = Exling.new("http://example.com") |>
        Exling.path("some")
        Exling.get("path")
      
  """
  def path(request, path) do
    if is_nil(request.uri.path) do
      %{request | uri: URI.merge(URI.parse(request.uri), path)}
    else
      update_in(request.uri.path, &(Path.join([&1, path])))
    end
  end

  defp set_method_and_uri(request, method, path) do 
    if is_nil(path) do
       %{request | method: method}
    else
       %{request | method: method} |> path(path)
    end
  end

  @doc """
  Set the method to GET and (optionally) add to the path. The optional extra path info is
  handy for REST APIs that may have multiple paths to an object with the final
  bit being an ID that might change often.

      r = Exline.new |>
        Exling.base("http://example.com") |>
        Exling.path("/things") |>
        Exling.get("1")
  """
  def get(request, path \\ nil), do: set_method_and_uri(request, :get, path)

  @doc """
  Set the HTTP method to POST. See `get` for more info and an example.
  """
  def post(request, path \\ nil), do: set_method_and_uri(request, :post, path)

  @doc """
  Set the HTTP method to DELETE. See `get` for more info and an example.
  """
  def delete(request, path \\ nil), do: set_method_and_uri(request, :delete, path)

  @doc """
  Set the HTTP method to PATCH. See `get` for more info and an example.
  """
  def patch(request, path \\ nil), do: set_method_and_uri(request, :patch, path)

  @doc """
  Set the HTTP method to HEAD. See `get` for more info and an example.
  """
  def head(request, path \\ nil), do: set_method_and_uri(request, :head, path)

  @doc """
  Set the HTTP method to OPTIONS. See `get` for more info and an example.
  """
  def options(request, path \\ nil), do: set_method_and_uri(request, :options, path)

  # headers
  @doc """
  Add the key/value pair to the HTTP headers. Additional calls for the same header type are appended.
  """
  def add(request, headers) when is_map(headers), do: update_in(request.headers, &(&1 ++ Map.to_list(headers)))
  def add(request, headers) when is_list(headers), do: update_in(request.headers, &(&1 ++ headers))
  def add(request, k, v), do: update_in(request.headers, &(&1 ++ [{k,v}]))

  @doc """
  Sed the key/value pair to the HTTP headers. Additional calls for the same header type will replace any previous entry.
  """
  def set(request, headers) when is_list(headers) or is_map(headers) do
    Enum.reduce(headers, request, fn({k,v}, acc) -> set(acc, k,v) end)
  end
  def set(request, k, v) do
    # replace the pair if they already exist, otherwise add it
    headers = case List.keymember?(request.headers, k, 0) do
                true -> List.keyreplace(request.headers, k, 0, {k,v})
                _ -> request.headers ++ [{k, v}]
              end
    %{request | headers: headers}
  end

  # type header convenience

  @doc """
  Set the HTTP Content-type header. Use `:json`, `:form`, `:xml` or `:plain`, or your 
  custom string if none of those apply. Note that using `body()` with the `:json`, 
  `:form`, or `:xml` options will set this for you, but if you need to override it 
  for some reason call this later in the chain.

      r = Exling.new("http://some.api.io")
        Exling.content_type(:plain)
        Exling.body("some string")
  """
  def content_type(request, type) when is_binary(type), do: set(request, "Content-type", type)
  def content_type(request, type) when is_atom(type) do
    case type do
      :json -> content_type(request, "application/json")
      :form -> content_type(request, "application/x-www-form-urlencoded")
      :xml -> content_type(request, "application/xml")
      :plain -> content_type(request, "text/plain")
      _ -> :error
    end
  end
  
  @doc """
  Set the HTTP Accept header. Use `:json`, `:form`, `:xml` or `:plain`, or your custom string if
  none of those apply.
  """
  def accept(request, type) when is_binary(type), do: set(request, "Accept", type)
  def accept(request, type) when is_atom(type) do
    case type do
      :json -> accept(request, "application/json")
      :form -> accept(request, "application/x-www-form-urlencoded")
      :xml -> accept(request, "application/xml")
      :plain -> accept(request, "text/plain")
      _ -> :error
    end
  end
  
  @doc """
  Set the request body. Use a type option to save yourself the trouble of
  setting the content type for common values. In the case of `:form` or
  `:json`, your body data should be a map and will automatically be encoded as
  well. `:xml` will set the content type but you are on your own for encoding,
  and if you have other content encoding needs, just use `body(my_body)` and
  set the content type yourself with `content_type` or `set`. 

      r = Exling.new |>
        Exling.base("http://foo.com") |>
        Exling.post() |>
        Exling.body(%{my: "stuff"}, :json)
  """
  def body(request, body, :form), do: %{request | body: {:form, body}} |> content_type(:form)
  def body(request, body, :json), do: %{request | body: Poison.encode!(body)} |> content_type(:json)
  def body(request, body, :xml), do: %{request | body: body} |> content_type(:xml)
  def body(request, body), do: %{request | body: body}

  defp append_query(uri, query, mod) do
    with stringified_uri <- URI.to_string(uri),
         encoded_query <- URI.encode_query(query),
         do: URI.parse(stringified_uri <> mod <> encoded_query)
  end
  
  @doc """
  Set query params with a map, keyword list, or key and value. Can be called
  multiple times to append new params.

      r = Exling.new |>
        Exling.base("http://foo.com") |>
        Exling.query(foo: "bar") |>
        Exling.query(:boo, "far") |>
        Exling.query(Keyword.new([{:b, 1}, {:a, 2}])) |>
        Exling.query(%{and: "more"})
  """
  def query(request, k, v), do: query(request, %{k => v})
  def query(request, query) when is_list(query), do: query(request, Enum.into(query, %{}))
  def query(request, query) when is_map(query) do
    uri = if request.uri.query do
      append_query(request.uri, query, "&")
    else
      append_query(request.uri, query, "?")
    end
    %{request | uri: uri}
  end
  
  @doc """
  Send the request. The return value is whatever your chosen client implementation returns.
  See `client` for supported implementations.

      {:ok, response} = Exling.new("http://some.api.io") |>
            Exling.client(HTTPoison)
            Exling.get("something") |>
            Exling.receive()
  """
  def receive(request, options \\ []) do
    case request.client do
      HTTPoison -> HTTPoison.request(request.method, URI.to_string(request.uri), request.body, request.headers, options)
      :hackney -> :hackney.request(request.method, URI.to_string(request.uri), request.headers, request.body, options)
      HTTPotion -> HTTPotion.request(request.method, URI.to_string(request.uri), [body: request.body, headers: request.headers] ++ options)
      :ibrowse -> :ibrowse.send_req(URI.to_string(request.uri) |> to_char_list, request.headers, request.method, request.body, options)
      f when is_function(f, 1) -> f.(request)
      f when is_function(f, 2) -> f.(request, options)
      _ -> raise "client not recognized"
    end
  end

end
