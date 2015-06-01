defmodule Templator.AppCreator do
  require EEx
  require Mix.Tasks.New

  def run(name) do
    Mix.Tasks.New.run([name])
    
    Templator.AppCreator.MixGenerator.generate_mix_file(name)
    Templator.AppCreator.AppGenerator.generate_app_file(name)
    Templator.AppCreator.HomeHandlerGenerator.generate_home_handler(name)

    {:ok, name}
  end

end
