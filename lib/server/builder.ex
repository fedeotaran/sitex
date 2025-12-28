defmodule Sitex.Server.Builder do
  use Plug.Builder

  require Logger

  alias Sitex.FileManager

  plug(Plug.Logger, log: :debug)

  plug(Plug.Static,
    at: "/",
    from: {FileManager, :build_folder, []},
    only: ~w(favicon.ico index.html feed.xml js css)
  )

  plug(:index)
  plug(:not_found)

  def index(%{path_info: path} = conn, _params) do
    build_folder_path = FileManager.build_folder() |> Path.absname()

    index_file =
      [build_folder_path, List.wrap(path), "index.html"]
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
