defmodule Example do
  @moduledoc """
  Documentation for Example.
  """

  def ip do
    Exling.new("https://httpbin.org") |> Exling.get("ip") |> Exling.receive()
  end
end
