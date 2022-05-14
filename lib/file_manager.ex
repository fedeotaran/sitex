defmodule Sitex.FileManager do
  alias Sitex.Config

  @paths Map.get(Config.load(), :paths, %{})
  @build_path Map.get(@paths, :build, "site")
  @statics_path Map.get(@paths, :statics, "priv/static")
  # @assets_path Map.get(@paths, :assets, "assets")

  def create_build_dir() do
    File.mkdir_p(@build_path)
  end

  def move_statics do
    if File.dir?(@statics_path), do: File.cp_r(@statics_path, @build_path)
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
    paths = [@build_path | files]
    Enum.join(paths, "/")
  end
end
