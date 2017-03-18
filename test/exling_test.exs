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

  end

  test "methods" do

  end

  test "headers" do

  end

  test "body" do

  end

  test "query" do

  end


end
