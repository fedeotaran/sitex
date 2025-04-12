defmodule Mix.Tasks.Sitex.Build do
  @moduledoc """
  Builds the static site from source files.

  This task performs the following operations:
  - Creates the build directory (default: `site/`)
  - Processes all markdown content in `content/pages/` and `content/posts/`
  - Applies templates from the selected theme
  - Generates HTML files in the build directory
  - Copies static assets

  ## Usage

      mix sitex.build

  The generated site will be available in the build directory specified in `sitex.yml`.
  """
  use Mix.Task
  require Logger

  @shortdoc "Build the static site"
  def run(_) do
    Logger.info("📄 Generating static site!")
    Sitex.Builder.build()
    Logger.info("✅ All Done!")
  end
end
