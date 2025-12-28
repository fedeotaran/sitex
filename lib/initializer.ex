defmodule Sitex.Initializer do
  alias Sitex.FileManager
  require Logger

  @default_opts [force: false]

  def init(opts \\ []) do
    opts = Keyword.merge(@default_opts, opts)
    copy_config(opts)
    copy_theme(opts)
    copy_static(opts)
    copy_content(opts)
    copy_ci(opts)
    update_gitignore()
  end

  defp copy_config(opts) do
    config_path = "./sitex.yml"
    source_path = Path.join([FileManager.defaults_dir(), "sitex.yml"])

    if File.exists?(config_path) do
      if opts[:force] ||
           confirm_overwrite?("Configuration file (sitex.yml) already exists. Overwrite? [y/N] ") do
        File.copy!(source_path, config_path)
      else
        Logger.info("Skipping configuration file creation.")
      end
    else
      File.copy!(source_path, config_path)
    end
  end

  defp copy_theme(opts) do
    theme_dir = "./themes/default/templates"
    source_dir = Path.join([FileManager.defaults_dir(), "templates"])
    favicon_source = Path.join([FileManager.defaults_dir(), "favicon.ico"])
    favicon_dest = "./themes/default/favicon.ico"

    if File.exists?(theme_dir) do
      if opts[:force] || confirm_overwrite?("Theme directory already exists. Overwrite? [y/N] ") do
        File.rm_rf!(theme_dir)
        File.mkdir_p!(theme_dir)
        File.cp_r!(source_dir, theme_dir)
        File.copy!(favicon_source, favicon_dest)
      else
        Logger.info("Skipping theme directory creation.")
      end
    else
      File.mkdir_p!(theme_dir)
      File.cp_r!(source_dir, theme_dir)
      File.copy!(favicon_source, favicon_dest)
    end
  end

  defp copy_static(opts) do
    static_dir = "./themes/default/static"
    source_dir = Path.join([FileManager.defaults_dir(), "static"])

    if File.exists?(static_dir) do
      if opts[:force] || confirm_overwrite?("Static directory already exists. Overwrite? [y/N] ") do
        File.rm_rf!(static_dir)
        File.mkdir_p!(static_dir)
        File.cp_r!(source_dir, static_dir)
      else
        Logger.info("Skipping static directory creation.")
      end
    else
      File.mkdir_p!(static_dir)
      File.cp_r!(source_dir, static_dir)
    end
  end

  defp copy_content(opts) do
    pages_dir = Path.join([FileManager.content_folder(), "pages"])
    posts_dir = Path.join([FileManager.content_folder(), "posts"])
    source_pages = Path.join([FileManager.defaults_dir(), "pages"])

    if File.exists?(pages_dir) do
      if opts[:force] || confirm_overwrite?("Content directory already exists. Overwrite? [y/N] ") do
        File.rm_rf!(pages_dir)
        File.mkdir_p!(pages_dir)
        File.mkdir_p!(posts_dir)
        File.cp_r!(source_pages, pages_dir)
      else
        Logger.info("Skipping content directory creation.")
      end
    else
      File.mkdir_p!(pages_dir)
      File.mkdir_p!(posts_dir)
      File.cp_r!(source_pages, pages_dir)
    end
  end

  defp copy_ci(opts) do
    ci_file = "./.github/workflows/ci.yml"
    source_ci_file = Path.join([FileManager.defaults_dir(), "ci.yml"])

    if File.exists?(ci_file) do
      if opts[:force] ||
           confirm_overwrite?("CI configuration file already exists. Overwrite? [y/N] ") do
        File.copy!(source_ci_file, ci_file)
      else
        Logger.info("Skipping CI configuration file creation.")
      end
    else
      File.mkdir_p!(Path.dirname(ci_file))
      File.copy!(source_ci_file, ci_file)
    end
  end

  defp update_gitignore do
    gitignore_path = "./.gitignore"
    build_folder = FileManager.build_folder()

    if File.exists?(gitignore_path) do
      content = File.read!(gitignore_path)

      unless String.contains?(content, "/#{build_folder}") do
        File.open(gitignore_path, [:append], fn file ->
          IO.binwrite(file, "\n/#{build_folder}\n")
        end)
      end
    else
      File.write!(gitignore_path, "/#{build_folder}\n")
    end
  end

  defp confirm_overwrite?(message) do
    IO.gets("#{IO.ANSI.yellow()}#{message}#{IO.ANSI.reset()}")
    |> String.trim()
    |> String.downcase()
    |> case do
      "y" -> true
      "yes" -> true
      _ -> false
    end
  end
end
