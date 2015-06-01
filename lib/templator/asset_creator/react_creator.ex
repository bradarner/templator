defmodule Templator.AssetCreator.ReactCreator do
  require Mix.Generator

  @react_src_files [
    {"http://cdnjs.cloudflare.com/ajax/libs/react/0.13.3/react-with-addons.js", "react.js"},
    {"http://cdnjs.cloudflare.com/ajax/libs/react/0.13.3/JSXTransformer.js", "JSXTransformer.js"},
    {"http://code.jquery.com/jquery-2.1.4.js", "jquery.js"}
  ]

  @react_dirs ["components"]

  def generate_files(name) do
    for {origin, output} <- @react_src_files do
      case HTTPoison.get(origin) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          create_src_file(name, output, body)
        {:ok, %HTTPoison.Response{status_code: 404}} ->
          IO.puts "Unable to find file: #{output}"
        _ ->
          IO.puts "Unable to make request for source file: #{output}"
      end
    end
  end

  def generate_dirs(name) do
    for path <- @react_dirs do
      Mix.Generator.create_directory("#{name}/priv/js/#{path}")
    end
  end
  
  def generate_index_html(name) do
    contents = EEx.eval_string(index_html_file, [module_name: Mix.Utils.camelize(name)])

    Mix.Generator.create_file("#{name}/templates/index.html", contents)
  end

  defp create_src_file(name, output_name, body) do
    Mix.Generator.create_file("#{name}/priv/js/#{output_name}", body)
  end

  def index_html_file do
    """
    <!DOCTYPE html>
    <html>
      <head>
        <title><%= module_name %> | A React App</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <script src="/js/react.js"></script>
        <script src="/js/JSXTransformer.js"></script>
        <script src="/js/jquery.js"></script>
      </head>
      <body>
        <div id="example"></div>
        <script type="text/jsx">
          React.render(
            <h1>Hello World!</h1>,
            document.getElementById("example")
          );
        </script>
      </body>
    </html>
    """
  end
end
