defmodule Sitex.Server.Watcher do
  use GenServer

  require Logger

  alias Sitex.Config
  alias Sitex.FileManager

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(_args) do
    {:ok, watcher_pid} =
      FileSystem.start_link(dirs: [content_folder(), FileManager.layout_folder()])

    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, _pid, {_path, _e}}, %{watcher_pid: _watcher_pid} = state) do
    Logger.debug("rebuilding...")
    Sitex.Builder.build()
    Logger.debug("done!")
    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    {:noreply, state}
  end

  defp content_folder() do
    Config.get()
    |> Map.get(:content, "content")
  end
end
