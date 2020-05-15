defmodule Sitex.FileManager do
  def load_post(file) do
    {:ok, text} = File.read("docs/#{file}")
    text
  end
end
