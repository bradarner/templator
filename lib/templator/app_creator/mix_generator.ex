defmodule Templator.AppCreator.MixGenerator do
  require EEx
  require Mix.Utils
  require Mix.Generator

  def generate_mix_file(name) do
    contents = EEx.eval_string(mix_body, [module_name: Mix.Utils.camelize(name), app_name: Mix.Utils.underscore(name)])

    case File.rm("#{name}/mix.exs") do
      :ok ->
        Mix.Generator.create_file("#{name}/mix.exs", contents) 
      _ ->
        IO.puts "Unable to delete existing mix.exs file"
    end
  end

  def mix_body do
    """
      defmodule <%= module_name %>.Mixfile do
        use Mix.Project

        def project do
          [
            app: :<%= app_name %>,
            version: "0.0.1",
            elixir: "~> 1.0",
            deps: deps
          ]
        end

        def application do
          [
            applications: [
              :logger,
              :cowboy
            ],
            mod: {<%= module_name %>, []}
          ]
        end

        defp deps do
          [
            {:cowboy, github: "ninenines/cowboy"}
          ]
        end
      end
    """
  end
end
