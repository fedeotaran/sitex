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
    build_feed()
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

  defp build_feed() do
    config = Config.get()
    posts = Blog.get_posts()

    site_url = Map.get(config, :site_url, "https://example.com")
    site_title = Map.fetch!(config, :title)
    site_description = Map.get(config, :description, "")

    xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
      <channel>
        <title>#{escape_xml(site_title)}</title>
        <link>#{escape_xml(site_url)}</link>
        <description>#{escape_xml(site_description)}</description>
        <atom:link href="#{escape_xml(site_url)}/feed.xml" rel="self" type="application/rss+xml" />
        <language>es</language>
    #{Enum.map_join(posts, "\n", &feed_item(&1, site_url))}
      </channel>
    </rss>
    """

    FileManager.write("feed.xml", xml)
  end

  defp feed_item(post, site_url) do
    """
        <item>
          <title>#{escape_xml(post.title)}</title>
          <link>#{escape_xml(site_url)}#{escape_xml(post.url)}</link>
          <description>#{escape_xml(post.description)}</description>
          <pubDate>#{format_rfc822_date(post.date)}</pubDate>
          <guid>#{escape_xml(site_url)}#{escape_xml(post.url)}</guid>
        </item>
    """
  end

  defp format_rfc822_date(date) do
    # Convert Date to RFC 822 format (e.g., "Mon, 01 Jan 2024 00:00:00 +0000")
    day_names = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    month_names = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ]

    day_of_week = day_names |> Enum.at(Date.day_of_week(date) - 1)
    month_name = month_names |> Enum.at(date.month - 1)

    "#{day_of_week}, #{String.pad_leading(to_string(date.day), 2, "0")} #{month_name} #{date.year} 00:00:00 +0000"
  end

  defp escape_xml(text) when is_binary(text) do
    text
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
    |> String.replace("'", "&apos;")
  end

  defp escape_xml(text), do: text
end
