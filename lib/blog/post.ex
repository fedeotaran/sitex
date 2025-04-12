defmodule Sitex.Blog.Post do
  alias __MODULE__

  @enforce_keys [:id, :author, :title, :body, :description, :tags, :date, :url]
  defstruct [:id, :author, :title, :body, :description, :tags, :date, :url]

  def build(filename, attrs, body) do
    [year, month_day_id] = filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    url = "blog/#{year}/#{month_day_id}"

    struct!(Post, [id: id, date: date, body: body, url: url] ++ Map.to_list(attrs))
  end
end
