defmodule Sitex.Builder do
  alias Sitex.FileManager
  alias Sitex.Blog
  alias Sitex.Parser
  alias Sitex.Config

  def build do
    FileManager.create_build_dir()
    build_posts()
    build_pages()
    FileManager.move_statics()
  end

  def code_style() do
    theme =
      Config.get()
      |> Map.get(:code_theme, "tango")

    String.to_atom("#{theme}_style")
    |> Makeup.stylesheet("makeup")
  end

  defp build_posts() do
    for entry <- Blog.get_entries() do
      build_post(entry)
    end
  end

  defp build_post({post, file_name}) do
    url =
      file_name
      |> Path.relative_to("content/posts/")
      |> Path.rootname()

    assigns = [inner_body: post.body, pages: pages(), title: post.title, posts: Blog.get_posts()]

    html = layout() |> render("eex", assigns)

    Path.join("blog", url)
    |> FileManager.write(html)
  end

  def build_pages() do
    for page <- pages(), do: build_page(page)
  end

  def build_page(page) do
    content = page_content(page)
    posts = Blog.get_posts()

    assigns = [inner_body: content, pages: pages(), title: page.title, posts: posts]

    html = layout() |> render("eex", assigns)

    FileManager.write(page.url, html)
  end

  defp page_content(%{url: '/'} = page) do
    content = render(page.file, "md")
    posts = Blog.get_posts()
    assigns = [inner_body: content, pages: pages(), title: page.title, posts: posts]

    index() |> render("eex", assigns)
  end

  defp page_content(page) do
    IO.inspect(page)
    render(page.file, "md")
  end

  defp index() do
    Path.join([FileManager.layout_folder(), "index.html.eex"])
  end

  defp layout() do
    Path.join([FileManager.layout_folder(), "layout.html.eex"])
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
