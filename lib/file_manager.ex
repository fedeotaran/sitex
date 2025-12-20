defmodule Sitex.FileManager do
  @priv_dir :code.priv_dir(:sitex)
  @defaults_dir Path.join([@priv_dir, "defaults"])

  alias Sitex.Config

  def defaults_dir() do
    @defaults_dir
  end

  def theme_folder() do
    theme = Config.get() |> Map.get("theme", "default")
    Path.join(["themes", theme])
  end

  def layout_folder() do
    theme_folder = theme_folder()
    Path.join([theme_folder, "templates"])
  end

  def content_folder() do
    Config.get()
    |> Map.get(:content_folder, "docs")
  end

  def build_folder() do
    Config.get()
    |> Map.get(:build_folder, "site")
  end

  def create_build_dir() do
    File.mkdir_p(build_folder())
  end

  def move_statics do
    move_favicon()
  end

  def write(_ = "/", file_content) do
    path = url_to_path("/")
    File.write(path, file_content)
    path
  end

  def write(url, file_content) do
    path = url_to_path(url)

    File.mkdir_p(path)

    [path, "index.html"]
    |> Path.join()
    |> File.write(file_content)

    path
  end

  defp move_favicon() do
    Path.join([theme_folder(), "favicon.ico"])
    |> File.cp!(Path.join([build_folder(), "favicon.ico"]))
  end

  defp url_to_path(url) do
    path =
      url
      |> to_string()
      |> String.split("/", trim: true)

    Path.join([build_folder() | path])
  end
end
