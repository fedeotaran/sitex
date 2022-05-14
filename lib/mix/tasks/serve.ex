defmodule Mix.Tasks.Sitex.Serve do
  use Mix.Task

  @doc false
  def run(_) do
    Mix.Tasks.Sitex.Build.run([""])
    Mix.Tasks.Run.run(["--no-halt"])
  end
end
