defmodule Sitex.Builder do
  alias Sitex.FileManager
  alias Sitex.Blog
  alias Sitex.Parser
  alias Sitex.Config

  def code_style() do
    theme =
      Config.get()
      |> Map.get(:code_theme, "tango")

    String.to_atom("#{theme}_style")
    |> Makeup.stylesheet("makeup")
  end

  def build do
    FileManager.create_build_dir()
    build_posts()
    build_pages()
    FileManager.move_statics()
  end

  defp build_posts() do
    for entry <- Blog.get_entries(), do: build_post(entry)
  end

  defp build_post({post, file_name}) do
    url =
      file_name
      |> Path.relative_to("content/posts/")
      |> Path.rootname()

    assigns = [inner_body: post.body, pages: pages(), title: post.title, posts: Blog.get_posts()]

    html = post() |> render("eex", assigns)

    Path.join("blog", url)
    |> FileManager.write(html)
  end

  def build_pages() do
    for page <- pages(), do: build_page(page)
  end

  def build_page(%{url: ~c"/"} = page) do
    posts = Blog.get_posts()
    inner_body = render(page.file, "md")

    assigns = [inner_body: inner_body, pages: pages(), title: page.title, posts: posts]

    html = index() |> render("eex", assigns)

    FileManager.write(page.url, html)
  end

  def build_page(page) do
    posts = Blog.get_posts()

    assigns = [
      inner_body: render(page.file, "md"),
      pages: pages(),
      title: page.title,
      posts: posts
    ]

    html = page() |> render("eex", assigns)

    FileManager.write(page.url, html)
  end

  def partial(file_name, opts \\ []) do
    [FileManager.layout_folder(), file_name]
    |> Path.join()
    |> EEx.eval_file(assigns: opts)
  end

  defp index() do
    Path.join([FileManager.layout_folder(), "index.html.heex"])
  end

  defp post() do
    Path.join([FileManager.layout_folder(), "post.html.heex"])
  end

  defp page() do
    Path.join([FileManager.layout_folder(), "page.html.heex"])
  end

  defp layout() do
    Path.join([FileManager.layout_folder(), "layout.html.heex"])
  end

  defp pages() do
    Map.fetch!(Config.get(), :pages)
  end

  defp render(layout, file_type, assigns \\ [])

  # Render markdown content for pages
  defp render(layout, "md", assigns) do
    layout
    |> File.read!()
    |> Parser.parse("md", assigns)
  end

  # Render content with index or page layout
  defp render(layout, "eex", assigns) do
    content =
      layout
      |> File.read!()
      |> Parser.parse("eex", assigns)

    # replate body for base layout
    assigns =
      assigns
      |> Keyword.put(:inner_body, content)

    render_base("eex", assigns)
  end

  # Render content with base layout
  defp render_base("eex", assigns) do
    base_layout = layout()

    base_layout
    |> File.read!()
    |> Parser.parse("eex", assigns)
  end
end
