defmodule ReceiveTest do
  use ExUnit.Case, async: false

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
    {:ok, %HTTPoison.Response{body: _body, headers: _headers, status_code: 200}} = Exling.new(endpoint_url(bypass.port))
 		|> Exling.get("foo")
		|> Exling.receive()
  end

  test ":hackney", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/foo" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, ~s<"some content">)
    end
    {:ok, 200, _response, _ref} = Exling.new(endpoint_url(bypass.port))
                |> Exling.client(:hackney)
 		|> Exling.get("foo")
		|> Exling.receive()
  end
  
  test "HTTPotion", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/foo" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, ~s<"some content">)
    end
    %HTTPotion.Response{body: _body, headers: _headers, status_code: 200}  = Exling.new(endpoint_url(bypass.port))
                |> Exling.client(HTTPotion)
 		|> Exling.get("foo")
		|> Exling.receive()
  end

  test ":ibrowse", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/foo" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, ~s<"some content">)
    end
    {:ok, '200', _headers, _body} = Exling.new(endpoint_url(bypass.port))
                |> Exling.client(:ibrowse)
 		|> Exling.get("foo")
		|> Exling.receive()

  end

  defp endpoint_url(port), do: "http://localhost:#{port}/"

end
