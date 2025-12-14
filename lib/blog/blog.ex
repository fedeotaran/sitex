defmodule Sitex.Blog do
  alias Sitex.FileManager

  def get_entries() do
    opts = [
      build: Sitex.Blog.Post,
      from: "#{FileManager.content_folder()}/posts/**/*.md",
      as: :posts,
      highlighters: []
    ]

    NimblePublisher.get_entries(opts)
    |> Tuple.to_list()
    |> Enum.zip()
  end

  def get_posts() do
    for {post, _} <- get_entries() do
      post
    end
    |> Enum.sort_by(& &1.date, {:desc, Date})
  end
end
