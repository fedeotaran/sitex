defmodule Sitex.Server.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Sitex.Server.Builder, options: [port: 4001]}
    ]

    opts = [strategy: :one_for_one, name: Sitex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
