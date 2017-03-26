defmodule Exling.Mixfile do
  use Mix.Project

  def project do
    [app: :exling,
r    version: "0.1.1",
     name: "Exling",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     description: description(),
     source_url: "https://github.com/joshrotenberg/exling"]
  end

  defp description do
    """
    Exling is an HTTP request builder.
    """
  end
  
  def application do
    [extra_applications: [:logger]]
  end

  defp package do
    [name: :exling,
    files: ["lib", "mix.exs", "README*", "LICENSE"],
    maintainers: ["Josh Rotenberg"],
    licenses: ["Apache 2.0"],
    links: %{"GitHub" => "https://github.com/joshrotenberg/exling"}]
  end

  defp deps do
    [{:httpoison, "~> 0.11.1"},
     {:poison, "~> 3.1"},
     {:ex_doc, "~> 0.14", only: :dev, runtime: false},
     {:bypass, "~> 0.6.0", only: :test},
     {:credo, "~> 0.5", only: [:dev, :test]}]
  end
end
