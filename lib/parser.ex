defmodule Sitex.Parser do
  @moduledoc """
  Documentation for `Sitex`.
  """

  def markdown(markdown_text) do
    markdown_text
    |> Earmark.as_html!(earmark_option())
  end

  def parse_eex(eex_text, assigns \\ []) do
    eex_text
    |> EEx.eval_string(assigns: assigns)
  end

  def render(file_name, assigns \\ []) do
    {:ok, file_content} = File.read(file_name)
    parse_eex(file_content, assigns)
  end

  def render_md(file_name) do
    {:ok, file_content} = File.read(file_name)
    markdown(file_content)
  end

  defp earmark_option do
    %Earmark.Options{
      code_class_prefix: "lang-",
      smartypants: false
    }
  end
end
