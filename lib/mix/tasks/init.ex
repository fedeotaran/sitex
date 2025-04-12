defmodule Mix.Tasks.Sitex.Init do
  @moduledoc """
  Initializes a new Sitex project with the basic structure and configuration.

  This task creates the following structure:
  - `sitex.yml`: Configuration file for the site
  - `themes/default/templates/`: Default theme templates
  - `content/pages/`: Directory for static pages
  - `content/posts/`: Directory for blog posts

  ## Usage

      mix sitex.init

  This will create all necessary directories and copy default templates and configuration.
  """
  use Mix.Task
  require Logger

  @shortdoc "Initialize a new Sitex project"
  def run(_) do
    Logger.info("🗂️ Generating initial files.")
    Sitex.Initializer.init()
    Logger.info("✅ All Done!")
  end
end
