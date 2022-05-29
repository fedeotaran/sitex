defmodule Sitex.Initializer do
  @priv_dir :code.priv_dir(:sitex)
  @defaults_dir Path.join([@priv_dir, "defaults"])

  alias Sitex.Config

  def init do
    copy_config()
    copy_theme()

    update_gitignore()
  end

  defp copy_config() do
    Path.join([@defaults_dir, "sitex.yml"])
    |> File.copy!('./sitex.yml')
  end

  defp copy_theme() do
    File.mkdir_p!("./themes/default/layout")

    Path.join([@defaults_dir, "layouts"])
    |> File.cp_r!("./themes/default/layout")

    Path.join([@defaults_dir, "favicon.ico"])
    |> File.copy!("./themes/default/favicon.ico")
  end

  # defp create_content_dirs do
  #   File.mkdir("./posts")
  #   File.mkdir("./drafts")
  #   File.mkdir("./pages")
  # end

  defp update_gitignore do
    File.open("./.gitignore", [:append], fn file ->
      IO.binwrite(file, "\n/#{build_folder()}\n")
    end)
  end

  defp build_folder() do
    Config.get()
    |> Map.get(:paths, %{})
    |> Map.get(:build, "site")
  end
end
