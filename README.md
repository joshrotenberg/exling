# Exling

[![Build Status](https://travis-ci.org/joshrotenberg/exling.svg?branch=master)](https://travis-ci.org/joshrotenberg/exling) [![Hex pm](http://img.shields.io/hexpm/v/exling.svg?style=flat)](https://hex.pm/packages/exling) [![hex.pm downloads](https://img.shields.io/hexpm/dt/exling.svg?style=flat)](https://hex.pm/packages/exling) [![Coverage Status](https://coveralls.io/repos/github/joshrotenberg/exling/badge.svg?branch=master)](https://coveralls.io/github/joshrotenberg/exling?branch=master)

![coverage](https://gitlab.com/joshrotenberg/exling/badges/master/coverage.svg?job=coverage)

> you don’t have to be a Jedi to fly an Exling

Exling is a fluent HTTP request builder for Elixir, inspired by the
[sling](https://github.com/dghubble/sling) library in Go. Exling uses Elixir
pipes to make building and executing HTTP requests clear and concise, and is
geared towards simplifying HTTP-based API library development, but should be
useful any time HTTP requests need to be made.

## Installation

Add `exling` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:exling, "~> 0.1.1"}]
end
```

## Usage

```elixir
# retrieve your ip address from httpbin.org
{:ok, response} = Exling.new |>
	          Exling.base("http://httpbin.org") |>
		  Exling.path("ip") |>
		  Exline.receive()

# send some post data and get JSON back
{:ok, response} = Exling.new |>
		    Exling.base("http://httpbin.org") |>
		    Exling.accept(:json)
		    Exling.post("post") |>
		    Exling.body(%{foo: "bar"}, :json) |>
		    Exling.receive()
```
## TODO

* typespecs
* unit tests
* more docs
* example app
* support multiple clients

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/exling](https://hexdocs.pm/exling).

