defmodule Templator.AssetCreator do
  alias Templator.AssetCreator.AngularCreator
  alias Templator.AssetCreator.ReactCreator
  require Mix.Generator

  @directories ["/priv", "/priv/js", "/priv/css", "/templates"]

  def run(name, framework) do
    name
    |> gen_dirs
    |> gen_framework_files(framework)

    :ok
  end

  def gen_dirs(name) do
    for path <- @directories do
      Mix.Generator.create_directory("#{name}#{path}")
    end

    name
  end

  def gen_framework_files(name, :angular) do
    AngularCreator.generate_files(name)


  end

  def gen_framework_files(name, :react) do
    ReactCreator.generate_dirs(name)
    ReactCreator.generate_files(name)
    ReactCreator.generate_index_html(name)
  end
end
