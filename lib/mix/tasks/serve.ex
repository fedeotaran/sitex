defmodule Mix.Tasks.Sitex.Serve do
  use Mix.Task

  @doc false
  def run(_) do
    Mix.Tasks.Run.run(["--no-halt"])
  end
end
