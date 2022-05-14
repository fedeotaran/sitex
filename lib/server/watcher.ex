defmodule Sitex.Server.Watcher do
  use GenServer

  require Logger

  alias Sitex.Config

  @content_path Map.get(Config.get(), :content, "content")
  @templates_path Map.get(Config.get(), :templates, "templates")

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(_args) do
    {:ok, watcher_pid} = FileSystem.start_link(dirs: [@content_path, @templates_path])

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
end
