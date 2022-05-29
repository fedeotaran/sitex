defmodule Sitex.Builder do
  alias Sitex.FileManager
  alias Sitex.Parser
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
    content = render(page.file, "md")

    html =
      [templates(), layout()]
      |> Enum.join("/")
      |> render("eex",
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

  defp render(file_name, file_type, assigns \\ []) do
    file_name
    |> File.read!()
    |> Parser.parse(file_type, assigns)
  end
end
