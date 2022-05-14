defmodule Sitex.Config.Loader do
  require Logger

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

  def load() do
    'sitex.yml'
    |> load_yml()
    |> List.flatten()
    |> to_map()
  end

  defp to_map(list) when is_list(list) and length(list) > 0 do
    first = List.first(list)

    cond do
      is_list(first) ->
        list
        |> Enum.map(&to_map/1)

      is_tuple(first) ->
        Enum.reduce(list, %{}, fn tuple, acc ->
          {key, value} = tuple
          Map.put(acc, String.to_atom(to_string(key)), to_map(value))
        end)

      true ->
        list
    end
  end

  defp to_map(tuple) when is_tuple(tuple) do
    {key, value} = tuple
    Enum.into([{String.to_atom(to_string(key)), to_map(value)}], %{})
  end

  defp to_map(value), do: value
end

defmodule Sitex.Config do
  @config Sitex.Config.Loader.load()

  def get() do
    @config
  end
end
