defmodule Sitex.Config.Loader do
  @moduledoc """
  Module responsible for loading and processing site configuration.

  Reads and processes the `sitex.yml` configuration file, converting it
  into an Elixir data structure that can be used by other modules
  in the system.
  """

  require Logger

  @doc """
  Loads a specific YAML file.

  ## Parameters

    * `file_name` - Path to the YAML file to load

  ## Example

      iex> Sitex.Config.Loader.load_yml("sitex.yml")
      [%{title: "My Site", ...}]

  ## Errors

  * Raises `RuntimeError` if the file doesn't exist
  * Raises `RuntimeError` if there's an error processing the YAML
  """
  def load_yml(file_name) do
    try do
      :yamerl_constr.file(file_name)
    catch
      {:yamerl_exception, _} ->
        Logger.error("Missing config file!")
        raise("Missing config file")

      _ ->
        raise("Unknow error!")
    end
  end

  @doc """
  Loads the default site configuration.

  Looks for and loads the `sitex.yml` file in the project root directory.

  ## Example

      iex> Sitex.Config.Loader.load()
      %{title: "My Site", ...}

  ## Expected Structure

  The YAML file should have the following basic structure:

      title: "My Site"
      description: "Site description"
      author: "Your Name"
      pages:
        - title: "Home"
          url: "/"
          file: "content/pages/index.md"
  """
  def load() do
    "sitex.yml"
    |> load_yml()
    |> List.flatten()
    |> to_map()
  end

  defp to_map([first | _] = list) do
    cond do
      is_list(first) ->
        list
        |> Enum.map(&to_map/1)

      is_tuple(first) ->
        Enum.reduce(list, %{}, fn {key, value}, acc ->
          Map.put(acc, String.to_atom(to_string(key)), to_map(value))
        end)

      true ->
        list
    end
  end

  defp to_map({key, value}) do
    Enum.into([{String.to_atom(to_string(key)), to_map(value)}], %{})
  end

  defp to_map(value), do: value
end

defmodule Sitex.Config do
  @moduledoc """
  Module that provides access to site configuration.

  This module acts as a simple interface to access the
  configuration loaded by `Sitex.Config.Loader`.
  """

  @doc """
  Gets the current site configuration.

  ## Example

      iex> Sitex.Config.get()
      %{
        title: "My Site",
        description: "Site description",
        pages: [...]
      }

  ## Default Values

  If certain values are not defined in the configuration file,
  the following default values will be used:

      %{
        title: "Sitex Site",
        description: "A static site generated with Sitex",
        author: "Sitex User",
        pages: []
      }
  """
  def get() do
    Sitex.Config.Loader.load()
  end
end
