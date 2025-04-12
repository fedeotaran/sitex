defmodule Sitex.MixProject do
  use Mix.Project

  def project do
    [
      app: :sitex,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Sitex.Server.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.6"},
      {:file_system, "~> 0.2.10"},
      {:yamerl, "~> 0.8.1"},
      {:nimble_publisher, path: "../nimble_publisher"},
      {:earmark, "~> 1.4.37"},
      {:makeup_elixir, "~> 0.16.1"},
      {:makeup_erlang, "~> 0.1.1"}
    ]
  end
end
