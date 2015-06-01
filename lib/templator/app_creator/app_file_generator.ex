defmodule Templator.AppCreator.AppGenerator do
  require EEx
  require Mix.Utils
  require Mix.Generator

  def generate_app_file(name) do
    contents = EEx.eval_string(app_file, [module_name: Mix.Utils.camelize(name), app_name: Mix.Utils.underscore(name)])

    case File.rm("#{name}/lib/#{Mix.Utils.underscore(name)}.ex") do
      :ok ->
        Mix.Generator.create_file("#{name}/lib/#{Mix.Utils.underscore(name)}.ex", contents)
      _ ->
        IO.puts "Unable to delete existing /lib/#{Mix.Utils.underscore(name)}.ex"
    end
  end

  def app_file do
    """
    defmodule <%= module_name %> do
      use Application

      def start(_types, _args) do
        start_server
      end

      def start_server(port \\\\ 4000) do
        :cowboy.start_http(:http, 100, [port: port], [env: [dispatch: dispatch_rules()]])

        IO.puts \"Listening for connections...\"

        waiting_loop
      end

      def dispatch_rules do
        :cowboy_router.compile(host_matches())
      end

      def host_matches do
        [{:_, 
          path_matches()
        }]
      end

      def path_matches do
        [
          {"/", <%= module_name %>.HomeHandler, []},
          {"/js/[...]", :cowboy_static, {:priv_dir, :<%= app_name %>, "/js"}},
          {"/css/[...]", :cowboy_static, {:priv_dir, :<%= app_name %>, "/css"}}
        ]
      end

      def waiting_loop do
        receive do
          _ -> waiting_loop
        end
      end
    end
    """
  end
end
