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
    r = Exling.new("http://fake.com") |> Exling.set("Key", "Value")
    assert r.headers == [{"Key", "Value"}]
    r = Exling.set(r, "Key", "OtherValue")
    assert r.headers == [{"Key", "OtherValue"}]

    r = Exling.new("http://fake.com") |> Exling.add("Key", "Value") |>
      Exling.add("Key", "OtherValue")
    assert r.headers == [{"Key", "Value"}, {"Key", "OtherValue"}]
    r = Exling.add(r, "Stuff", "Here")
    assert r.headers == [{"Key", "Value"}, {"Key", "OtherValue"}, {"Stuff", "Here"}]

    r = Exling.new("http://fake.com") |> Exling.add("Key", "Value") |>
      Exling.add(%{"Key" => "OtherValue", "Stuff" => "Here"})
    assert r.headers == [{"Key", "Value"}, {"Key", "OtherValue"}, {"Stuff", "Here"}]

    r = Exling.new("http://fake.com") |> Exling.add("Key", "Value") |>
      Exling.add([{"Key", "OtherValue"}, {"Stuff", "Here"}])
    assert r.headers == [{"Key", "Value"}, {"Key", "OtherValue"}, {"Stuff", "Here"}]

    r = Exling.new("http://fake.com") |> Exling.set("K", "V") 
    assert r.headers == [{"K", "V"}]

    r = Exling.new("http://fake.com") |> Exling.set("K", "V") |> Exling.set("K", "D")
    assert r.headers == [{"K", "D"}]

    r = Exling.new("http://fake.com") |> Exling.set("K", "d") |> Exling.set([{"k", "v"}, {"r", "i"}])
    assert r.headers == [{"K", "d"}, {"k", "v"}, {"r", "i"}]
    
    r = Exling.new("http://fake.com") |> Exling.set("K", "d") |> Exling.set(%{"k" => "v", "r" => "i"})
    assert r.headers == [{"K", "d"}, {"k", "v"}, {"r", "i"}]
  end

  test "body" do
    r = Exling.new() |> Exling.base("http://fake.com") |> Exling.body("stuff")
    assert r.body != nil
  end

  test "query" do

  end

  test "client" do
  end

end
