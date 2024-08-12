defmodule Nbpm.MixProject do
  use Mix.Project

  def project do
    elixir_version = System.version()
    styler_compat = Version.compare(elixir_version, "1.14.0")

    [
      app: :nbpm,
      version: "0.3.1",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      description: description(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      docs: docs(),
      deps: deps(styler_compat)
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
    "Nbpm is a custom EPMD module that maps Erlang node names to network ports."
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/pertsevds/nbpm"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps(styler_compat) when styler_compat in [:gt, :eq] do
    [
      {:patch, "~> 0.13.1", only: [:test]},
      {:excoveralls, "~> 0.10", only: :test, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:styler, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.30", only: :dev, runtime: false}
    ]
  end

  defp deps(_) do
    [
      {:patch, "~> 0.13.1", only: [:test]},
      {:excoveralls, "~> 0.10", only: :test, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.30", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md"
      ]
    ]
  end
end
