defmodule Sitex.Server.Application do
  @moduledoc false
  use Application

  require Logger

  def start(_type, _args) do
    Logger.debug("Starting Application...")

    port = 80

    children = [
      {Sitex.Server.Watcher, []},
      {Plug.Cowboy, scheme: :http, plug: Sitex.Server.Builder, options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: Sitex.Supervisor]
    {:ok, pid} = Supervisor.start_link(children, opts)

    Logger.debug("Server is runing in port: #{port}")

    {:ok, pid}
  end
end
