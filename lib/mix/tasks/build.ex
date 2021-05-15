defmodule Mix.Tasks.Sitex.Build do
  use Mix.Task
  require Logger

  @shortdoc "Build de application."
  def run(_) do
    Logger.info("Generating files..")
    Sitex.Builder.build()
    Logger.info("All Done!")
  end
end
