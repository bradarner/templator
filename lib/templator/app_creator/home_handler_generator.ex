defmodule Templator.AppCreator.HomeHandlerGenerator do
  require EEx
  require Mix.Utils
  require Mix.Generator


  def generate_home_handler(name) do
    Mix.Generator.create_directory("#{name}/lib/#{Mix.Utils.underscore(name)}")

    contents = EEx.eval_string(home_handler_file, [module_name: Mix.Utils.camelize(name)])

    Mix.Generator.create_file("#{name}/lib/#{Mix.Utils.underscore(name)}/home_handler.ex", contents)
  end

  def home_handler_file do
    """
    defmodule <%= module_name %>.HomeHandler do
      def init(request, options) do
        reply = request |> build_reply
        {:ok, reply, options}
      end

      def build_reply(request) do
        :cowboy_req.reply(status_code(), headers(), body(), request)
      end

      def status_code, do: 200

      def headers, do: [{"content-type", "text/html"}]

      def body do
        File.read!("templates/index.html")
      end
    end
    """
  end
end
