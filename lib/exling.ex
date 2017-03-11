defmodule Exling do
  @moduledoc """
  Documentation for Exling.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Exling.hello
      :world

  """
  def hello do
    :world
  end


  def new(), do:
     %Exling.Request{}
  
  def base(request, base), do:
    %{request | raw_url: base}

  # methods
  #
  def get(request), do:
    %{request | method: :get}

  def post(request), do:
    %{request | method: :post}

  def delete(request), do:
    %{request | method: :delete}

  def patch(request), do: 
    %{request | method: :patch}

  def head(request), do:
    %{request | method: :head}

  # headers
  def add(request, k, v) do
    update_in(request.headers, &List.insert_at(&1, 0, [k,v]))
  end

end
