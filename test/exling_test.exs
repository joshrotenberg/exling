defmodule ExlingTest do
  use ExUnit.Case
  doctest Exling

  test "new" do
    r = Exling.new()
    assert r.body == ""
    assert r.client == :httpoison
    assert r.headers == []
    assert r.method == :get
    assert r.uri == %URI{authority: nil, fragment: nil, host: nil, path: nil, port: nil,
      query: nil, scheme: nil, userinfo: nil}

    r = Exling.new("http://fake.com")
    assert r.body == ""
    assert r.client == :httpoison
    assert r.headers == []
    assert r.method == :get
    assert r.uri == %URI{authority: "fake.com", fragment: nil, host: "fake.com", path: nil, 
      port: 80, query: nil, scheme: "http", userinfo: nil}
  end

  test "base" do
    r = Exling.new |> Exling.base("http://fake.com")
    assert r.body == ""
    assert r.client == :httpoison
    assert r.headers == []
    assert r.method == :get
    assert r.uri == %URI{authority: "fake.com", fragment: nil, host: "fake.com", path: nil, 
      port: 80, query: nil, scheme: "http", userinfo: nil}
    
    r = Exling.new |> Exling.base("http://fake.com/path?doof=cha")
    assert r.body == ""
    assert r.client == :httpoison
    assert r.headers == []
    assert r.method == :get
    assert r.uri == %URI{authority: "fake.com", fragment: nil, host: "fake.com", path: "/path", 
      port: 80, query: "doof=cha", scheme: "http", userinfo: nil}
  end

  test "path" do
    r = Exling.new |> Exling.base("http://fake.com") |> Exling.path("somepath")
    assert r.body == ""
    assert r.uri.path == "/somepath"

    r = Exling.path(r, "andmore")
    assert r.uri.path == "/somepath/andmore"

    r = Exling.post(r, "wqkejn")
    assert r.uri.path == "/somepath/andmore/wqkejn"
  end

  test "methods" do
    r = Exling.new("http://fake.com") 
    assert r.method == :get

    r = Exling.new("http://fake.com") |> Exling.post()
    assert r.method == :post
    
    r = Exling.new("http://fake.com") |> Exling.get()
    assert r.method == :get

    r = Exling.new("http://fake.com") |> Exling.delete()
    assert r.method == :delete
 
    r = Exling.new("http://fake.com") |> Exling.patch()
    assert r.method == :patch

    r = Exling.new("http://fake.com") |> Exling.options()
    assert r.method == :options
    
    r = Exling.new("http://fake.com") |> Exling.get("stuff")
    assert r.method == :get
    assert r.uri.path == "/stuff"

  end

  test "headers" do

  end

  test "body" do

  end

  test "query" do

  end


end
