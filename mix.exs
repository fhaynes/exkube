defmodule Exkube.Mixfile do
  use Mix.Project

  def project do
    [app: :exkube,
     version: "0.1.1",
     description: description(),
     package: package(),
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      extra_applications: [:logger],
      applications: [:httpoison, :poison]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.11.2"},
      {:poison, "~> 3.1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    A module for interacting with Kubernetes clusters
    """
  end

  defp package do
    # These are the default files included in the package
    [
      name: :exkube,
      maintainers: ["Fletcher Haynes <fletcher@unity3d.com>"],
      licenses: ["Apache 2.0"],
      links: links()
    ]
  end

  defp links do
    %{"GitHub" => "https://github.com/fhaynes/exkube"}
  end

end
