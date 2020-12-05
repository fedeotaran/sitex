defmodule Sitex.FileManager do
  def move_assets do
    File.cp_r("assets", "site/")
  end

  def write(file_name \\ "home", file_content)

  def write(_ = "home", file_content) do
    File.write("site/index.html", file_content)
  end

  def write(file_name, file_content) do
    File.mkdir_p("site/#{file_name}")
    File.write("site/#{file_name}/index.html", file_content)
  end
end
