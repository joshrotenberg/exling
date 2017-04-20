defmodule ReceiveTest do
  use ExUnit.Case, async: true

  setup do
    bypass = Bypass.open
    {:ok, bypass: bypass}
  end

  test "HTTPoison", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/foo" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, ~s<"some content">)
    end
    assert {:ok, _} = Exling.new(endpoint_url(bypass.port))
 		|> Exling.get("foo")
		|> Exling.receive()
  end

  test ":hackney", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/foo" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, ~s<"some content">)
    end
    assert {:ok, 200, _, _} = Exling.new(endpoint_url(bypass.port))
                |> Exling.client(:hackney)
 		|> Exling.get("foo")
		|> Exling.receive()
  end
  defp endpoint_url(port), do: "http://localhost:#{port}/"

end
