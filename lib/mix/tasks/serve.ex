defmodule Mix.Tasks.Sitex.Serve do
  @moduledoc """
  Starts a local development server and watches for changes.

  This task:
  - Builds the site using `mix sitex.build`
  - Starts a local server (default port: 80)
  - Watches for changes in content and templates
  - Automatically rebuilds the site when changes are detected

  ## Usage

      mix sitex.serve

  The server will be available at `http://localhost:80` by default.
  Any changes to content or templates will trigger an automatic rebuild.
  """
  use Mix.Task

  @shortdoc "Start development server with live reload"
  def run(_) do
    Mix.Tasks.Sitex.Build.run([""])
    Mix.Tasks.Run.run(["--no-halt"])
  end
end
