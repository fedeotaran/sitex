defmodule Sitex do
  @moduledoc """
  Sitex is a simple and efficient static site generator written in Elixir.

  ## Main Features

  * Static site generation from Markdown files
  * Blog support with post system
  * Customizable templates using EEx
  * Simple YAML configuration
  * No Node.js dependencies
  * Pico CSS integration for styling

  ## Usage Example

      # Create a new site
      mix sitex.new my_site

      # Build the site
      mix sitex.build

      # Serve the site locally
      mix sitex.serve

  ## Project Structure

  A typical Sitex project has the following structure:

      my_site/
      ├── content/
      │   ├── posts/      # Blog posts
      │   └── pages/      # Static pages
      ├── layouts/        # EEx templates
      ├── static/         # Static files
      └── sitex.yml       # Site configuration

  ## Configuration

  Configuration is handled through the `sitex.yml` file. Example:

      title: "My Site"
      description: "A static site generated with Sitex"
      author: "Your Name"
      pages:
        - title: "Home"
          url: "/"
          file: "content/pages/index.md"
        - title: "About"
          url: "/about"
          file: "content/pages/about.md"

  For more information about configuration, see the `Sitex.Config` documentation.
  """

  @doc """
  Main function to build the site.

  This function coordinates the static site building process,
  including page and post generation.

  ## Example

      iex> Sitex.build()
      :ok

  """
  def build do
    Sitex.Builder.build()
  end

  @doc """
  Starts a local server to preview the site.

  ## Options

    * `:port` - Port where the site will be served (default: 4000)
    * `:host` - Host where the site will be served (default: "localhost")

  ## Example

      iex> Sitex.serve(port: 4000)
      {:ok, #PID<0.123.0>}

  """
  def serve(opts \\ []) do
    Sitex.Server.start(opts)
  end
end
