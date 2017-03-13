defmodule Exling do
  @moduledoc """
  Documentation for Exling.
  """

  @doc """
    Returns a new Exling.Request.
  """
  def new(), do:
  %Exling.Request{}

  @doc """
    Set the base URI (or really as much URI information as you want).

    ## Examples
      r = Exling.new |> 
          Exling.base("http://example.com")
  """
  def base(request, base), do:
  %{request | uri: URI.parse(base)}

  defp set_method_and_uri(request, method, path), do: 
  %{request | method: method, uri: URI.merge(request.uri, path)}

  @doc """
    Set the URI path.

    ## Examples
    r = Exling.new |>
        Exling.base("http://example.com") |>
        Exling.path("/some/path")
  """
  def path(request, path), do:
  set_method_and_uri(request, request.method, path)

  # methods
  def get(request, path), do:
  set_method_and_uri(request, :get, path)

  def post(request, path), do:
  set_method_and_uri(request, :post, path)

  def delete(request, path), do:
  set_method_and_uri(request, :delete, path)

  def patch(request, path), do: 
  set_method_and_uri(request, :patch, path)

  def head(request, path), do:
  set_method_and_uri(request, :head, path)

  def options(request, path), do:
  set_method_and_uri(request, :options, path)

  # headers
  def add(request, k, v) do
    update_in(request.headers, &List.insert_at(&1, 0, {k,v}))
  end

  def set(request, k, v) do
    headers = case List.keymember?(request.headers, k, 0) do
      true -> List.keyreplace(request.headers, k, 0, {k,v})
      _ -> request.headers ++ [{k, v}]
    end
    Map.merge(request, %{headers: headers})
  end

  # body
  def body(request, body), do:
  %{request | body: body}

  def body_form(request, body), do:
  %{request | body: {:form, body}}

  def body_json(request, body), do:
  %{request | body: Poison.encode!(body)}

  def query(request, query), do:
  %{request | uri: URI.merge(request.uri, URI.parse("?" <> URI.encode_query(query)))}

end
