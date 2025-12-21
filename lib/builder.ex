defmodule Sitex.Builder do
  @moduledoc """
  Module responsible for building the static site.

  This module handles the generation of all site pages,
  including blog posts and static pages. It coordinates the
  rendering process using EEx templates and Markdown content.

  ## Building Process

  1. Creates the build directory
  2. Generates blog posts
  3. Generates static pages
  4. Copies static files

  ## Example

      iex> Sitex.Builder.build()
      :ok
  """

  alias Sitex.FileManager
  alias Sitex.Blog
  alias Sitex.Parser
  alias Sitex.Config

  @doc """
  Builds the entire static site.

  This is the main entry point for site generation.
  It coordinates the building of posts, pages, and copying of static files.

  ## Example

      iex> Sitex.Builder.build()
      :ok

  ## Process

  1. Creates the build directory
  2. Generates all blog posts
  3. Generates all static pages
  4. Copies static files to the build directory
  """
  def build do
    FileManager.create_build_dir()
    build_posts()
    build_pages()
    build_blog()
    FileManager.move_statics()
  end

  defp build_blog() do
    blog = blog()
    posts = Blog.get_posts()

    assigns = [
      pages: pages(),
      blog: blog,
      title: blog.title,
      posts: Blog.get_posts(),
      site_title: Config.get() |> Map.fetch!(:title),
      code_theme: Config.get() |> Map.get(:code_theme, "github")
    ]

    html = blog_view() |> render("eex", assigns)

    FileManager.write("blog/index.html", html)
  end

  defp build_posts() do
    for entry <- Blog.get_entries(), do: build_post(entry)
  end

  defp build_post({post, file_name}) do
    url =
      file_name
      |> Path.relative_to("#{FileManager.content_folder()}/posts/")
      |> Path.rootname()

    assigns = [
      inner_body: post.body,
      pages: pages(),
      blog: blog(),
      title: post.title,
      description: post.description,
      author: post.author,
      date: post.date,
      tags: post.tags,
      posts: Blog.get_posts(),
      site_title: Config.get() |> Map.fetch!(:title),
      code_theme: Config.get() |> Map.get(:code_theme, "github")
    ]

    html = post_view() |> render("eex", assigns)
    path = Path.join(["blog", url, "index.html"])

    FileManager.write(path, html)
  end

  def build_pages() do
    for page <- pages(), do: build_page(page)
  end

  def build_page(%{url: ~c"/"} = page) do
    posts = Blog.get_posts()
    inner_body = render(page.file, "md")

    assigns = [
      inner_body: inner_body,
      pages: pages(),
      blog: blog(),
      title: page.title,
      posts: posts,
      site_title: Config.get() |> Map.fetch!(:title),
      code_theme: Config.get() |> Map.get(:code_theme, "github")
    ]

    html = index_view() |> render("eex", assigns)

    FileManager.write("index.html", html)
  end

  def build_page(page) do
    posts = Blog.get_posts()

    assigns = [
      inner_body: render(page.file, "md"),
      pages: pages(),
      blog: blog(),
      title: page.title,
      posts: posts,
      site_title: Config.get() |> Map.fetch!(:title),
      code_theme: Config.get() |> Map.get(:code_theme, "github")
    ]

    html = page_view() |> render("eex", assigns)

    dir =
      page.url
      |> to_string()
      |> String.split("/", trim: true)
      |> Path.join()

    path = Path.join([dir, "index.html"])

    FileManager.write(path, html)
  end

  defp index_view() do
    Path.join([FileManager.layout_folder(), "index.html.heex"])
  end

  defp post_view() do
    Path.join([FileManager.layout_folder(), "post.html.heex"])
  end

  defp page_view() do
    Path.join([FileManager.layout_folder(), "page.html.heex"])
  end

  defp layout_view() do
    Path.join([FileManager.layout_folder(), "layout.html.heex"])
  end

  defp blog_view() do
    Path.join([FileManager.layout_folder(), "blog.html.heex"])
  end

  defp pages() do
    Map.fetch!(Config.get(), :pages)
  end

  defp blog() do
    Map.fetch!(Config.get(), :blog)
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
    base_layout = layout_view()

    base_layout
    |> File.read!()
    |> Parser.parse("eex", assigns)
  end
end
