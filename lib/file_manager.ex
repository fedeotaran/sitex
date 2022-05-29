defmodule Sitex.FileManager do
  @priv_dir :code.priv_dir(:sitex)
  @defaults_dir Path.join([@priv_dir, "defaults"])

  alias Sitex.Config

  def defaults_dir() do
    @defaults_dir
  end

  def create_build_dir() do
    File.mkdir_p(build_folder())
  end

  def move_statics do
    move_favicon()
    if File.dir?(statics_folder()), do: File.cp_r(statics_folder(), build_folder())
  end

  def write(file_name \\ 'home', file_content)

  def write(_ = 'home', file_content) do
    build_path(["index.html"])
    |> File.write(file_content)
  end

  def write(file_name, file_content) do
    [file_name]
    |> build_path()
    |> File.mkdir_p()

    [file_name, "index.html"]
    |> build_path()
    |> File.write(file_content)
  end

  defp build_path(files) do
    paths = [build_folder() | files]
    Enum.join(paths, "/")
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
end
