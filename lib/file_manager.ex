defmodule Sitex.FileManager do
  def move_assets do
    File.cp_r("theme/assets", "public/")
  end

  def write(file_name \\ "home", file_content)

  def write(_ = "home", file_content) do
    File.write("public/index.html", file_content)
  end

  def write(file_name, file_content) do
    File.mkdir_p("public/#{file_name}")
    File.write("public/#{file_name}/index.html", file_content)
  end
end
