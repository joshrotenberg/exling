defmodule Exling.Mixfile do
  use Mix.Project

  def project do
    [app: :exling,
     version: "0.1.2",
     name: "Exling",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     deps: deps(),
     package: package(),
     description: description(),
     source_url: "https://gitlab.com/joshrotenberg/exling"]
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
    links: %{"GitHub" => "https://gitlab.com/joshrotenberg/exling"}]
  end

  defp deps do
    [{:poison, "~> 3.1"},
     {:httpoison, "~> 0.11.1", only: [:dev, :test]},
     {:ibrowse, "~> 4.4", only: [:dev, :test]},
     {:httpotion, "~> 3.0", only: [:dev, :test]},
     {:hackney, "~> 1.7", only: [:dev, :test]},
     {:ex_doc, "~> 0.14", only: :dev, runtime: false},
     {:bypass, "~> 0.6.0", only: :test},
     {:excoveralls, "~> 0.6", only: :test},
     {:credo, "~> 0.5", only: [:dev, :test]}]
  end
end
