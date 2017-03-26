# Exling

Exling is a fluent HTTP request builder for Elixir, inspired by the
[sling](https://github.com/dghubble/sling) library in Go. Exling uses Elixir
pipes to make building and executing HTTP requests clear and concise, and is
geared towards simplifying HTTP-based API library development, but should be
useful any time HTTP requests need to be made.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exling` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:exling, "~> 0.1.0"}]
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

