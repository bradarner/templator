defmodule Templator do
  alias Templator.AppCreator
  alias Templator.AssetCreator

  def build_template({:new, framework, name}) do
    case AppCreator.run(name) do
      {:ok, _} ->
        case AssetCreator.run(name, framework) do
          :ok ->
            IO.puts "Asset files created"

            get_deps(name)

            IO.puts """

              Template Created!

              Next Step:

                $> cd #{name}
                $> mix

                Visit http://localhost:4000


            """
           _ -> 
            IO.puts "Unable to create asset files"
            exit(:normal)
        end
      _ ->
        IO.puts "Unable to create the app"
        exit(:normal)
    end
  end

  def get_deps(name) do
    File.cd!("#{name}")
    IO.puts "Changing to #{inspect File.cwd!()}"  

    IO.puts "Getting dependencies.."
    System.cmd("mix", ["deps.get"])

    IO.puts "Compiling dependencies.."
    System.cmd("mix", ["deps.compile"])
  end
end
