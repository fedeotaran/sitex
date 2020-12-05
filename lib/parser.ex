defmodule Sitex.Parser do
  @moduledoc """
  Documentation for `Sitex`.
  """

  def render(file_name, file_type \\ "eex", assigns \\ [])

  def render(file_name, _ = "eex", assigns) do
    {:ok, file_content} = File.read(file_name)
    eex(file_content, assigns)
  end

  def render(file_name, _ = "md", _) do
    {:ok, file_content} = File.read(file_name)
    markdown(file_content)
  end

  defp markdown(markdown_text) do
    markdown_text
    |> Earmark.as_html!(earmark_option())
  end

  defp eex(eex_text, assigns) do
    eex_text
    |> EEx.eval_string(assigns: assigns)
  end

  defp earmark_option do
    %Earmark.Options{
      code_class_prefix: "lang-",
      smartypants: false
    }
  end
end
