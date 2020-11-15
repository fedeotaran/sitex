defmodule Sitex do
  @moduledoc """
  Documentation for `Sitex`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Sitex.hello()
      :world

  """
  def hello do
    :world
  end

  def sections do
    [
      %{title: "Home", file: "docs/sections/home.md", slug: "home"},
      %{title: "About Me", file: "docs/sections/about.md", slug: "about"}
    ]
  end

  def build do
    File.mkdir_p('site')

    for section <- sections() do
      content = Sitex.Parser.render_md(section.file)

      html =
        Sitex.Parser.render(
          'web/layouts/layout.html.eex',
          content: content,
          sections: sections(),
          title: section.title
        )

      write_file(section.slug, html)
    end
  end

  def write_file(_="home", file_content) do
    File.write("site/index.html", file_content)
  end

  def write_file(file_name, file_content) do
    File.mkdir_p("site/#{file_name}")
    File.write("site/#{file_name}/index.html", file_content)
  end
end
