defmodule Sitex.Parser do
  @moduledoc """
  Documentation for `Sitex`.
  """

  def markdown(markdown_text) do
    markdown_text
    |> Earmark.as_html!(earmark_option())
  end

  def parse_eex(eex_text) do
    eex_text
    |> EEx.eval_string(assigns: [title: "Hola Mundo!"])
  end

  def render(file_name) do
    {:ok, file_content} = File.read(file_name)
    parse_eex(file_content)
  end

  defp earmark_option do
    %Earmark.Options{
      code_class_prefix: "lang-",
      smartypants: false
    }
  end
end
