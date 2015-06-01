defmodule Templator.CLI do
  @moduledoc """
  Handle the command line parsing and initial set up of the files to generate
  """
  
  def main(argv) do
    argv
    |> parse_args
    |> process
    |> Templator.build_template
  end 

  def parse_args(args) do
    OptionParser.parse(args, strict: [
      help: :boolean, 
      react: :boolean,
      angular: :boolean
    ], aliases: [
      h: :help,
      r: :react,
      a: :angular
    ])
  end

  def process({[{:help, true} | _], _, _}) do
    IO.puts """
      usage: templator <action> <name> [options]
    """
  end

  def process({[{:angular, true}, {:react, true} | _], _, _}) do
    IO.puts """
      Unable to generate both angular and react templates at the same time
    """
  end

  def process({[{:angular, true} | _], ["new", name], _}) do
    IO.puts """
      
      You want to create an app by the name of #{name}
      You want it to be an Angular app  

    """

    {:new, :angular, name}
  end

  def process({[{:angular, true} | _], ["generate", name], _}) do
    IO.puts """

      You want to run a generator named #{name}
      Unfortunately, this feature is not yet implemented

    """
  end

  def process({[{:react, true} | _], ["new", name], _}) do
    IO.puts """
      
      You want to create an app by the name of #{name}
      You want it to be a React app  

    """

    {:new, :react, name}
  end

  def process({[{:react, true} | _], ["generate", name], _}) do
    IO.puts """

      You want to run a generator named #{name}
      Unfortunately, this feature is not yet implemented

    """
  end
end
