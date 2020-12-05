defmodule Sitex do
  @moduledoc """
  Documentation for `Sitex`.
  """

  def pages do
    [
      %{title: "Home", file: "content/pages/home.md", slug: "home", url: "/"},
      %{title: "About Me", file: "content/pages/about.md", slug: "about", url: "/about"}
    ]
  end

  def build do
    File.mkdir_p('public')

    for page <- pages() do
      content = Sitex.Parser.render(page.file, "md")

      html =
        Sitex.Parser.render(
          'templates/layout.html.eex',
          "eex",
          content: content,
          pages: pages(),
          title: page.title
        )

      Sitex.FileManager.write(page.slug, html)
    end

    Sitex.FileManager.move_assets
  end
end
