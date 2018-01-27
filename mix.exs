defmodule Cbuf.MixProject do
  use Mix.Project

  def project do
    [
      app: :cbuf,
      version: "0.1.0",
      elixir: "~> 1.6",
      package: package(),
      description: "A circular buffer backed by Erlang's array",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end

  defp package do
    [maintainers: ["Clark Kampfe"],
     licenses: ["MIT"],
     links: %{"Github" => "https://github.com/ckampfe/cbuf"}]
  end
end
