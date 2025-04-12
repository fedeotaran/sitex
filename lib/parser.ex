defmodule Sitex.Parser do
  @moduledoc """
  Documentation for `Sitex`.
  """

  def parse(content, file_type, assigns \\ [])

  def parse(markdown_content, _ = "md", _assigns) do
    markdown_content
    |> Earmark.as_html!(earmark_option())
  end

  def parse(eex_content, _ = "eex", assigns) do
    eex_content
    |> EEx.eval_string(assigns: assigns)
  end

  defp earmark_option do
    %Earmark.Options{
      code_class_prefix: "language-",
      smartypants: false
    }
  end
end
