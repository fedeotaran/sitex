defmodule Sitex.Blog do
  def get_entries() do
    opts = [
      build: Sitex.Blog.Post,
      from: "./content/posts/**/*.md",
      as: :posts,
      highlighters: [:makeup_elixir, :makeup_erlang]
    ]

    NimblePublisher.get_entries(opts)
    |> Tuple.to_list()
    |> Enum.zip()
  end

  def get_posts() do
    for {post, _} <- get_entries(), do: post
  end
end
