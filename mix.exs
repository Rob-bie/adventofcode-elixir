defmodule AdventOfCode.Mixfile do
  use Mix.Project

  def project do
    [app: :adventofcode,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:exprof,  "~> 0.2.0"},
     {:poison, "~> 1.5"}]
  end
end
