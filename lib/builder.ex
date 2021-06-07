defmodule Sitex.Builder do
  alias Sitex.FileManager
  alias Sitex.View
  alias Sitex.Config

  @paths Map.get(Config.load(), :paths, %{})
  @templates_path Map.get(@paths, :templates, "templates")
  @layout_name Map.get(Config.load(), :layout, "layout.html.eex")
  @pages Map.fetch!(Config.load(), :pages)

  def build do
    FileManager.create_build_dir()
    build_pages()
    FileManager.move_assets()
  end

  def build_pages() do
    for page <- @pages do
      build_page(page)
    end
  end

  def build_page(page) do
    content = View.render(page.file, "md")

    html =
      [@templates_path, @layout_name]
      |> Enum.join("/")
      |> View.render("eex",
        content: content,
        pages: @pages,
        title: page.title
      )

    FileManager.write(page.slug, html)
  end
end
