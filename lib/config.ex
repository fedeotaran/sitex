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
  def get() do
    Sitex.Config.Loader.load()
  end
end
