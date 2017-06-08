defmodule Exling.Client do
  @type request :: Exling.Request
  @callback receive(request) :: {:ok, term} | {:error, term}
end

defmodule Exling.Client.HTTPotion do
  @behaviour Exling.Client
  def receive(request) do 
    IO.inspect request
    {:ok, "foo"}
  end
end
