defmodule Sitex.Builder do
  alias Sitex.FileManager
  alias Sitex.View
  alias Sitex.Config

  def build do
    FileManager.create_build_dir()
    build_pages()
    FileManager.move_statics()
  end

  def build_pages() do
    for page <- pages() do
      build_page(page)
    end
  end

  def build_page(page) do
    content = View.render(page.file, "md")

    html =
      [templates(), layout()]
      |> Enum.join("/")
      |> View.render("eex",
        content: content,
        pages: pages(),
        title: page.title
      )

    FileManager.write(page.slug, html)
  end

  defp templates() do
    Map.get(Config.get(), :paths, %{})
    |> Map.get(:templates, "templates")
  end

  defp layout() do
    Map.get(Config.get(), :layout, "layout.html.eex")
  end

  defp pages() do
    Map.fetch!(Config.get(), :pages)
  end
end
