defmodule Jsonpath.MixProject do
  use Mix.Project

  def project do
    [
      app: :jsonpath,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      deps_path: "build/deps",
      build_path: "build/dev"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Jsonpath, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:exjsonpath, "~> 0.1"},
      {:poison, "~> 3.1"}
    ]
  end
end
