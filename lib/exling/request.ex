defmodule Exling.Request do
  defstruct uri: nil, method: :get, body: "", headers: [], client: nil
  @type t :: %__MODULE__{uri: %URI{}, method: atom, body: term, headers: list, client: atom}
end
