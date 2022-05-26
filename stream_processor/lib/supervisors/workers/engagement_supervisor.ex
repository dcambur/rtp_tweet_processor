defmodule SSE.Supervisor.EngagementWorker do
  @moduledoc """
  worker process supervisor with a function to
  dynamically create a worker on demand
  """
  use DynamicSupervisor

  @worker_proc SSE.Process.EngagementWorker

  def start_link(name) do
    DynamicSupervisor.start_link(__MODULE__, [], [name: name])
  end

  def init([]) do
    IO.puts("engagement worker supervisor #{inspect(self())} starts up...")
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_child(scaler_proc, worker_sup) do
    child_spec = %{
      id: :worker,
      start: {@worker_proc, :start_link, [scaler_proc]},
      type: :worker,
      restart: :transient,
    }
    DynamicSupervisor.start_child(worker_sup, child_spec)
  end

  @doc """
  terminates first child in the list
  """
  def free_child(worker_sup) do
    child_pids = DynamicSupervisor.which_children(worker_sup)
    {_, child_pid, _, _ } = Enum.at(child_pids, 0)

    DynamicSupervisor.terminate_child(worker_sup, child_pid)
  end
end
