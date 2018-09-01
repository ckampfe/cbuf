defmodule Cbuf.MixProject do
  use Mix.Project

  def project do
    [
      app: :cbuf,
      version: "0.6.0",
      elixir: "~> 1.5",
      package: package(),
      description: "A circular buffer backed by a map or ETS",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        flags: [
          "-Wunmatched_returns",
          :error_handling,
          :race_conditions,
          :underspecs
        ]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:benchee, "~> 0.11", only: :dev},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:stream_data, "~> 0.1", only: :test},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Clark Kampfe"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/ckampfe/cbuf"}
    ]
  end
end
