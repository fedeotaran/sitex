defmodule Mix.Tasks.Sitex.Init do
  use Mix.Task
  require Logger

  @shortdoc "Init file for site"
  def run(_) do
    Logger.info("🗂️ Generating initial files.")
    Sitex.Initializer.init()
    Logger.info("✅ All Done!")
  end
end
