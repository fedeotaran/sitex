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
      %{title: "Home", file: "docs/sections/home.md", slug: 'home'},
      %{title: "About Me", file: "docs/sections/about.md", slug: 'about'}
    ]
  end

  def build do
    File.mkdir_p('build')
    for section <- sections() do
      with {:ok, content} <- File.read(section[:file]) do
        html = Sitex.Parser.render('web/layouts/layout.html.eex')
        File.write("")
      end
    end
  end
end
