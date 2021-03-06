defmodule ExlingTest do
  use ExUnit.Case
  doctest Exling

  @fake_host "http://fake.com"
  test "new" do
    r = Exling.new()
    assert r.body == ""
    assert r.client == HTTPoison
    assert r.headers == []
    assert r.method == :get
    assert r.uri == %URI{authority: nil, fragment: nil, host: nil, path: nil, port: nil,
      query: nil, scheme: nil, userinfo: nil}

    r = Exling.new(@fake_host)
    assert r.body == ""
    assert r.client == HTTPoison
    assert r.headers == []
    assert r.method == :get
    assert r.uri == %URI{authority: "fake.com", fragment: nil, host: "fake.com", path: nil, 
      port: 80, query: nil, scheme: "http", userinfo: nil}
  end

  test "base" do
    r = Exling.new |> Exling.base(@fake_host)
    assert r.body == ""
    assert r.client == HTTPoison
    assert r.headers == []
    assert r.method == :get
    assert r.uri == %URI{authority: "fake.com", fragment: nil, host: "fake.com", path: nil, 
      port: 80, query: nil, scheme: "http", userinfo: nil}
    
    r = Exling.new |> Exling.base(@fake_host <> "/path?doof=cha")
    assert r.body == ""
    assert r.client == HTTPoison
    assert r.headers == []
    assert r.method == :get
    assert r.uri == %URI{authority: "fake.com", fragment: nil, host: "fake.com", path: "/path", 
      port: 80, query: "doof=cha", scheme: "http", userinfo: nil}
  end

  test "path" do
    r = Exling.new |> Exling.base(@fake_host) |> Exling.path("somepath")
    assert r.body == ""
    assert r.uri.path == "/somepath"

    r = Exling.path(r, "andmore")
    assert r.uri.path == "/somepath/andmore"

    r = Exling.post(r, "wqkejn")
    assert r.uri.path == "/somepath/andmore/wqkejn"
  end

  test "methods" do
    r = Exling.new(@fake_host) 
    assert r.method == :get

    r = Exling.new(@fake_host) |> Exling.get()
    assert r.method == :get

    r = Exling.new(@fake_host) |> Exling.get("stuff")
    assert r.method == :get
    assert r.uri.path == "/stuff"

    r = Exling.new(@fake_host) |> Exling.post()
    assert r.method == :post

    r = Exling.new(@fake_host) |> Exling.post("stuff")
    assert r.method == :post
    assert r.uri.path == "/stuff"

    r = Exling.new(@fake_host) |> Exling.delete()
    assert r.method == :delete
    
    r = Exling.new(@fake_host) |> Exling.delete("stuff")
    assert r.method == :delete
    assert r.uri.path == "/stuff"
 
    r = Exling.new(@fake_host) |> Exling.patch()
    assert r.method == :patch

    r = Exling.new(@fake_host) |> Exling.patch("stuff")
    assert r.method == :patch
    assert r.uri.path == "/stuff"

    r = Exling.new(@fake_host) |> Exling.options()
    assert r.method == :options

    r = Exling.new(@fake_host) |> Exling.options("stuff")
    assert r.method == :options
    assert r.uri.path == "/stuff"
  end

  test "headers" do
    r = Exling.new(@fake_host) |> Exling.set("Key", "Value")
    assert r.headers == [{"Key", "Value"}]
    r = Exling.set(r, "Key", "OtherValue")
    assert r.headers == [{"Key", "OtherValue"}]

    r = Exling.new(@fake_host) |> Exling.add("Key", "Value") |>
      Exling.add("Key", "OtherValue")
    assert r.headers == [{"Key", "Value"}, {"Key", "OtherValue"}]
    r = Exling.add(r, "Stuff", "Here")
    assert r.headers == [{"Key", "Value"}, {"Key", "OtherValue"}, {"Stuff", "Here"}]

    r = Exling.new(@fake_host) |> Exling.add("Key", "Value") |>
      Exling.add(%{"Key" => "OtherValue", "Stuff" => "Here"})
    assert r.headers == [{"Key", "Value"}, {"Key", "OtherValue"}, {"Stuff", "Here"}]

    r = Exling.new(@fake_host) |> Exling.add("Key", "Value") |>
      Exling.add([{"Key", "OtherValue"}, {"Stuff", "Here"}])
    assert r.headers == [{"Key", "Value"}, {"Key", "OtherValue"}, {"Stuff", "Here"}]

    r = Exling.new(@fake_host) |> Exling.set("K", "V") 
    assert r.headers == [{"K", "V"}]

    r = Exling.new(@fake_host) |> Exling.set("K", "V") |> Exling.set("K", "D")
    assert r.headers == [{"K", "D"}]

    r = Exling.new(@fake_host) |> Exling.set("K", "d") |> Exling.set([{"k", "v"}, {"r", "i"}])
    assert r.headers == [{"K", "d"}, {"k", "v"}, {"r", "i"}]
    
    r = Exling.new(@fake_host) |> Exling.set("K", "d") |> Exling.set(%{"k" => "v", "r" => "i"})
    assert r.headers == [{"K", "d"}, {"k", "v"}, {"r", "i"}]
  end

  test "accept" do
    r = Exling.new(@fake_host) |> Exling.accept(:json)
    assert r.headers == [{"Accept", "application/json"}]
    
    r = Exling.new(@fake_host) |> Exling.accept(:form)
    assert r.headers == [{"Accept", "application/x-www-form-urlencoded"}]

    r = Exling.new(@fake_host) |> Exling.accept(:xml)
    assert r.headers == [{"Accept", "application/xml"}]
    
    r = Exling.new(@fake_host) |> Exling.accept(:plain)
    assert r.headers == [{"Accept", "text/plain"}]
  
    r = Exling.new(@fake_host) |> Exling.accept("application/something-else-json")
    assert r.headers == [{"Accept", "application/something-else-json"}]
  end

  test "content type" do
    r = Exling.new(@fake_host) |> Exling.content_type(:json)
    assert r.headers == [{"Content-type", "application/json"}]
    
    r = Exling.new(@fake_host) |> Exling.content_type(:form)
    assert r.headers == [{"Content-type", "application/x-www-form-urlencoded"}]
    
    r = Exling.new(@fake_host) |> Exling.content_type(:xml)
    assert r.headers == [{"Content-type", "application/xml"}]
    
    r = Exling.new(@fake_host) |> Exling.content_type("application/other-stuff-json")
    assert r.headers == [{"Content-type", "application/other-stuff-json"}]
  
  end
  
  test "body" do
    r = Exling.new() |> Exling.base(@fake_host) |> Exling.body("stuff")
    assert r.body == "stuff"
    
    r = Exling.new() |> Exling.base(@fake_host) |> Exling.body(%{some: "stuff"}, :json)
    assert r.headers == [{"Content-type", "application/json"}]
    assert r.body == "{\"some\":\"stuff\"}"

    r = Exling.new() |> Exling.base(@fake_host) |> Exling.body(%{some: "stuff"}, :form)
    assert r.body == {:form, %{some: "stuff"}}
    assert r.headers == [{"Content-type", "application/x-www-form-urlencoded"}]
    
    r = Exling.new() |> Exling.base(@fake_host) |> Exling.body("<xml!>", :xml)
    assert r.headers == [{"Content-type", "application/xml"}]
  end

  test "query" do
    r = Exling.new(@fake_host) |> Exling.query("Key", "Value")
    assert r.uri.query == "Key=Value"

    r = Exling.new(@fake_host) |> Exling.query(%{"Key" => "Value"})
    assert r.uri.query == "Key=Value"

    r = Exling.new(@fake_host) |> Exling.query([{"Key", "Value"}])
    assert r.uri.query == "Key=Value"
  end

  test "client" do
    r = Exling.new(@fake_host) |> Exling.client(HTTPoison)
    assert r.client == HTTPoison

    r = Exling.new(@fake_host) |> Exling.client(HTTPotion)
    assert r.client == HTTPotion
    
    r = Exling.new(@fake_host) |> Exling.client(:hackney)
    assert r.client == :hackney
    
    r = Exling.new(@fake_host) |> Exling.client(:ibrowse)
    assert r.client == :ibrowse

    assert_raise RuntimeError, fn -> 
      Exling.new(@fake_host) |> Exling.client(:notreal)
    end
  end

end
