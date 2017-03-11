defmodule Exling.Request do
  defstruct raw_url: "", method: :get, body_plain: "", body_form: %{}, body_json: %{}, headers: [], query: %{}
end
