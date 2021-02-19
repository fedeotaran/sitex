defmodule Sitex do
  @moduledoc """
  Documentation for `Sitex`.
  """
  alias Sitex.FileManager
  alias Sitex.View
  alias Sitex.Config

  @templates_path Config.load().paths.templates
  @layout_name Config.load().layout

  def pages do
    [
      %{title: "Home", file: "content/pages/home.md", slug: "home", url: "/"},
      %{title: "About Me", file: "content/pages/about.md", slug: "about", url: "/about"}
    ]
  end

  def build do
    FileManager.create_build_dir()
    build_pages()
    FileManager.move_assets()
  end

  defp build_pages() do
    for page <- pages() do
      content = View.render(page.file, "md")

      html =
        [@templates_path, @layout_name]
        |> Enum.join("/")
        |> View.render("eex", content: content, pages: pages(), title: page.title)

      FileManager.write(page.slug, html)
    end
  end
end
