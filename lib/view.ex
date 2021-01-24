defmodule Sitex.View do
  @moduledoc """
  Documentation for `Sitex`.
  """
  alias Sitex.Parser

  def render(file_name, file_type, assigns \\ []) do
    file_name
    |> File.read!()
    |> Parser.parse(file_type, assigns)
  end
end
