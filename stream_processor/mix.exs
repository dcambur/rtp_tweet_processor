defmodule STREAM_PROCESSOR.MixProject do
  use Mix.Project

  def project do
    [
      app: :stream_processor,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {SSE.App, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:poison, "~> 5.0"},
      {:ecto_sql, "~> 3.7"},
      {:postgrex, ">= 0.0.0"}
    ]
  end
end
