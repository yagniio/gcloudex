defmodule GCloudex.Mixfile do
  use Mix.Project

  @version "0.4.2"

  def project do
    [
     app: :gcloudex,
     version: @version,
     elixir: "~> 1.2",
     description: "Google Cloud for Elixir. Friendly set of wrappers for "
                   <> "Google Cloud Platform API's.",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :goth]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.8.0"},
      {:goth,      "~> 0.0.1"},
      {:poison,    "~> 1.5.2"},
      {:credo,     "~> 0.3", only: [:dev, :test]}
    ]
  end

  defp package do 
    [
     maintainers: ["Sasha Fonseca"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/sashaafm/gcloudex"}
    ]    
  end
end
