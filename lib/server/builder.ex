defmodule Sitex.Server.Builder do
  use Plug.Builder

  plug(Plug.Logger)
  plug(Plug.Static, at: "/", from: "public")
  plug(:index)
  plug(:not_found)

  def index(%{path_info: path} = conn, _params) do
    index_file =
      ["public", List.wrap(path), "index.html"]
      |> List.flatten()
      |> Path.join()
      |> File.read!()

    send_resp(conn, 200, index_file) |> halt()
  end

  def not_found(conn, _) do
    send_resp(conn, 404, "Not Found!")
  end
end
