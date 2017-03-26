defmodule Exling.Request do
  defstruct uri: nil, method: :get, body: "", headers: [], client: :httpoison
  @type t :: %__MODULE__{uri: %URI{}, method: atom, body: term, headers: list, client: atom}
end
