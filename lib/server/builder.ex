defmodule Sitex.Server.Builder do
  use Plug.Builder
  require Logger
  alias Sitex.Config

  @build_path Map.get(Config.load(), :build, "site")

  plug(Plug.Logger, log: :debug)
  plug(Plug.Static, at: "/", from: @build_path, only: ~w(favicon.ico index.html))
  plug(:index)
  plug(:not_found)

  def index(%{path_info: path} = conn, _params) do
    index_file =
      [@build_path, List.wrap(path), "index.html"]
      |> List.flatten()
      |> Path.join()
      |> File.read!()

    conn
    |> put_resp_header("Content-Type", "text/html; charset=UTF-8")
    |> send_resp(200, index_file)
    |> halt()
  end

  def not_found(conn, _) do
    conn
    |> put_resp_header("Content-Type", "text/html; charset=UTF-8")
    |> send_resp(404, "Not Found!")
    |> halt()
  end
end
