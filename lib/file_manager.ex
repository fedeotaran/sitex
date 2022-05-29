defmodule Sitex.FileManager do
  @priv_dir :code.priv_dir(:sitex)
  @defaults_dir Path.join([@priv_dir, "defaults"])

  alias Sitex.Config

  def defaults_dir() do
    @defaults_dir
  end

  def layout_folder() do
    theme = Config.get() |> Map.get("theme", "default")

    Path.join(["themes", theme, "layouts"])
  end

  def create_build_dir() do
    File.mkdir_p(build_folder())
  end

  def move_statics do
    move_favicon()
    if File.dir?(statics_folder()), do: File.cp_r(statics_folder(), build_folder())
  end

  def write(_ = "/", file_content) do
    url_to_path("/")
    |> File.write(file_content)
  end

  def write(url, file_content) do
    path = url_to_path(url)

    File.mkdir_p(path)

    [path, "index.html"]
    |> Path.join()
    |> File.write(file_content)
  end

  def build_folder() do
    Config.get()
    |> Map.get(:paths, %{})
    |> Map.get(:build, "site")
    |> Path.absname()
  end

  defp statics_folder() do
    Config.get()
    |> Map.get(:paths, %{})
    |> Map.get(:build, "priv/static")
    |> Path.absname()
  end

  defp move_favicon() do
    Path.join([defaults_dir(), "favicon.ico"])
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
