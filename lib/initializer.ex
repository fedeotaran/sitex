defmodule Sitex.Initializer do
  alias Sitex.FileManager

  def init do
    copy_config()
    copy_theme()

    update_gitignore()
  end

  defp copy_config() do
    Path.join([FileManager.defaults_dir(), "sitex.yml"])
    |> File.copy!('./sitex.yml')
  end

  defp copy_theme() do
    File.mkdir_p!("./themes/default/templates")

    Path.join([FileManager.defaults_dir(), "templates"])
    |> File.cp_r!("./themes/default/templates")

    Path.join([FileManager.defaults_dir(), "favicon.ico"])
    |> File.copy!("./themes/default/favicon.ico")
  end

  defp update_gitignore do
    File.open("./.gitignore", [:append], fn file ->
      IO.binwrite(file, "\n/#{FileManager.build_folder()}\n")
    end)
  end
end
